/* This file is part of the dynarmic project.
 * Copyright (c) 2024 dynarmic contributors
 * SPDX-License-Identifier: 0BSD
 * 
 * LoongArch64 port: Assembly-based testing framework for A32 (ARM32)
 * 
 * This is a standalone test program that compiles and runs ARM32 assembly tests.
 * Each test is defined in a .s file with a JSON config block in a C-style comment.
 * 
 * Usage: asmtest_a32 [test_directory]
 * 
 * Test file format (.s files):
 * 
 *   / * CONFIG
 *   {
 *     "Match": "All",
 *     "RegData": {
 *       "R0": "0x0000002A",
 *       "R1": "0x00000032",
 *       "SP": "0x00001000"
 *     },
 *     "VecData": {
 *       "D0": "0x0000000100000001",
 *       "Q0": "0x00000001000000020000000300000004"
 *     }
 *   }
 *   * /
 *   
 *   .text
 *   .arm
 *   .global _start
 *   _start:
 *       mov r0, #42
 *       add r1, r0, #8
 *       bkpt #0   // Test end marker
 */

#include <algorithm>
#include <array>
#include <cctype>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <map>
#include <memory>
#include <sstream>
#include <string>
#include <vector>

#include <fmt/format.h>
#include <cassert>

using u8 = std::uint8_t;
using u16 = std::uint16_t;
using u32 = std::uint32_t;
using u64 = std::uint64_t;

#include "dynarmic/interface/A32/a32.h"
#include "dynarmic/interface/A32/coprocessor.h"
#include "dynarmic/interface/exclusive_monitor.h"
#include "dynarmic/interface/halt_reason.h"

namespace fs = std::filesystem;

// ============================================================================
// JSON Parser (minimal, no external dependencies)
// ============================================================================

class JsonValue;
using JsonObject = std::map<std::string, JsonValue>;
using JsonArray = std::vector<JsonValue>;

class JsonValue {
public:
    enum class Type { Null, String, Number, Bool, Array, Object };
    
    Type type = Type::Null;
    std::string string_val;
    int64_t number_val = 0;
    bool bool_val = false;
    JsonArray array_val;
    JsonObject object_val;
    
    bool IsString() const { return type == Type::String; }
    bool IsArray() const { return type == Type::Array; }
    bool IsObject() const { return type == Type::Object; }
    
    const std::string& AsString() const { return string_val; }
    const JsonArray& AsArray() const { return array_val; }
    const JsonObject& AsObject() const { return object_val; }
    
    const JsonValue* Get(const std::string& key) const {
        if (type != Type::Object) return nullptr;
        auto it = object_val.find(key);
        return it != object_val.end() ? &it->second : nullptr;
    }
};

class JsonParser {
public:
    JsonParser(const std::string& s) : src(s), pos(0) {}
    
    JsonValue Parse() {
        SkipWhitespace();
        return ParseValue();
    }
    
private:
    const std::string& src;
    size_t pos;
    
    void SkipWhitespace() {
        while (pos < src.size() && std::isspace(static_cast<unsigned char>(src[pos]))) pos++;
    }
    
    char Peek() { return pos < src.size() ? src[pos] : '\0'; }
    char Get() { return pos < src.size() ? src[pos++] : '\0'; }
    
    JsonValue ParseValue() {
        SkipWhitespace();
        char c = Peek();
        
        if (c == '"') return ParseString();
        if (c == '[') return ParseArray();
        if (c == '{') return ParseObject();
        if (c == 't' || c == 'f') return ParseBool();
        if (c == '-' || std::isdigit(static_cast<unsigned char>(c))) return ParseNumber();
        
        return JsonValue{};  // null
    }
    
    JsonValue ParseString() {
        Get();  // skip opening "
        std::string s;
        while (Peek() != '"' && Peek() != '\0') {
            if (Peek() == '\\') {
                Get();
                char esc = Get();
                switch (esc) {
                    case 'n': s += '\n'; break;
                    case 't': s += '\t'; break;
                    case 'r': s += '\r'; break;
                    case '\\': s += '\\'; break;
                    case '"': s += '"'; break;
                    default: s += esc; break;
                }
            } else {
                s += Get();
            }
        }
        Get();  // skip closing "
        
        JsonValue v;
        v.type = JsonValue::Type::String;
        v.string_val = s;
        return v;
    }
    
    JsonValue ParseArray() {
        Get();  // skip [
        JsonArray arr;
        SkipWhitespace();
        
        while (Peek() != ']' && Peek() != '\0') {
            arr.push_back(ParseValue());
            SkipWhitespace();
            if (Peek() == ',') Get();
            SkipWhitespace();
        }
        Get();  // skip ]
        
        JsonValue v;
        v.type = JsonValue::Type::Array;
        v.array_val = arr;
        return v;
    }
    
    JsonValue ParseObject() {
        Get();  // skip {
        JsonObject obj;
        SkipWhitespace();
        
        while (Peek() != '}' && Peek() != '\0') {
            JsonValue key_val = ParseString();
            SkipWhitespace();
            Get();  // skip :
            JsonValue val = ParseValue();
            obj[key_val.string_val] = val;
            SkipWhitespace();
            if (Peek() == ',') Get();
            SkipWhitespace();
        }
        Get();  // skip }
        
        JsonValue v;
        v.type = JsonValue::Type::Object;
        v.object_val = obj;
        return v;
    }
    
    JsonValue ParseBool() {
        JsonValue v;
        v.type = JsonValue::Type::Bool;
        if (src.substr(pos, 4) == "true") {
            v.bool_val = true;
            pos += 4;
        } else if (src.substr(pos, 5) == "false") {
            v.bool_val = false;
            pos += 5;
        }
        return v;
    }
    
    JsonValue ParseNumber() {
        std::string num;
        if (Peek() == '-') num += Get();
        while (std::isalnum(static_cast<unsigned char>(Peek())) || Peek() == '.' || Peek() == 'x' || Peek() == 'X') {
            num += Get();
        }
        
        JsonValue v;
        v.type = JsonValue::Type::Number;
        v.string_val = num;  // Keep as string for hex parsing
        return v;
    }
};

// ============================================================================
// Test Configuration
// ============================================================================

struct AsmTestConfig {
    std::string match_mode = "All";
    std::string known_failure;  // If set, test is expected to fail with this reason
    std::string bucket;
    std::string source_repro;
    std::map<std::string, uint32_t> expected_regs;
    std::map<std::string, uint32_t> init_regs;
    std::map<std::string, uint64_t> expected_dregs;  // D registers (64-bit)
    std::map<std::string, uint64_t> init_dregs;
    std::map<std::string, std::pair<uint64_t, uint64_t>> expected_qregs;  // Q registers (128-bit)
    std::map<std::string, std::pair<uint64_t, uint64_t>> init_qregs;
    std::map<uint32_t, std::vector<uint8_t>> data_mem_init;  // Data memory initialization
    std::map<uint32_t, std::vector<uint8_t>> expected_mem_data;
    std::map<uint32_t, std::vector<uint8_t>> tls_mem_init;   // TLS memory initialization
    uint32_t tpidrurw_init = 0x3000;
    uint32_t tpidruro_init = 0x3000;
    uint32_t init_cpsr = 0x10;
    uint32_t expected_cpsr = 0;
    bool has_expected_cpsr = false;
    uint32_t init_fpscr = 0;
    uint32_t expected_fpscr = 0;
    bool has_expected_fpscr = false;
    uint64_t max_ticks = 10000;
    struct SvcAction {
        uint32_t svc_num = 0;
        std::string action;
        uint32_t offset = 0;
        uint32_t value = 0;
        std::string result_reg;
    };
    std::vector<SvcAction> svc_actions;
    bool valid = false;
};

uint32_t ParseUint32(const std::string& s) {
    return static_cast<uint32_t>(std::stoul(s, nullptr, 0));
}

uint64_t ParseUint64(const std::string& s) {
    return std::stoull(s, nullptr, 0);
}

AsmTestConfig ParseTestConfig(const std::string& json) {
    AsmTestConfig config;
    
    JsonParser parser(json);
    JsonValue root = parser.Parse();
    
    if (!root.IsObject()) return config;
    
    // Parse Match mode
    const JsonValue* match = root.Get("Match");
    if (match && match->IsString()) {
        config.match_mode = match->AsString();
    }
    
    // Parse KnownFailure
    const JsonValue* known_failure = root.Get("KnownFailure");
    if (known_failure && known_failure->IsString()) {
        config.known_failure = known_failure->AsString();
    }

    const JsonValue* bucket = root.Get("Bucket");
    if (bucket && bucket->IsString()) {
        config.bucket = bucket->AsString();
    }

    const JsonValue* source_repro = root.Get("SourceRepro");
    if (source_repro && source_repro->IsString()) {
        config.source_repro = source_repro->AsString();
    }

    const JsonValue* set_cpsr = root.Get("SetCpsr");
    if (set_cpsr && set_cpsr->IsString()) {
        config.init_cpsr = ParseUint32(set_cpsr->AsString());
    }
    const JsonValue* expected_cpsr = root.Get("ExpectedCpsr");
    if (expected_cpsr && expected_cpsr->IsString()) {
        config.expected_cpsr = ParseUint32(expected_cpsr->AsString());
        config.has_expected_cpsr = true;
    }
    const JsonValue* set_fpscr = root.Get("SetFpscr");
    if (set_fpscr && set_fpscr->IsString()) {
        config.init_fpscr = ParseUint32(set_fpscr->AsString());
    }
    const JsonValue* expected_fpscr = root.Get("ExpectedFpscr");
    if (expected_fpscr && expected_fpscr->IsString()) {
        config.expected_fpscr = ParseUint32(expected_fpscr->AsString());
        config.has_expected_fpscr = true;
    }
    const JsonValue* max_ticks = root.Get("MaxTicks");
    if (max_ticks && max_ticks->IsString()) {
        config.max_ticks = ParseUint64(max_ticks->AsString());
    }

    // Parse RegData
    const JsonValue* regdata = root.Get("RegData");
    if (regdata && regdata->IsObject()) {
        for (const auto& [name, val] : regdata->AsObject()) {
            if (val.IsString()) {
                std::string name_upper = name;
                for (auto& c : name_upper) c = std::toupper(c);
                
                // Parse register name
                if (name_upper[0] == 'R') {
                    // R0-R15 (including PC = R15)
                    config.expected_regs[name] = ParseUint32(val.AsString());
                } else if (name_upper == "SP") {
                    config.expected_regs["SP"] = ParseUint32(val.AsString());
                } else if (name_upper == "PC") {
                    config.expected_regs["PC"] = ParseUint32(val.AsString());
                } else if (name_upper == "LR") {
                    config.expected_regs["LR"] = ParseUint32(val.AsString());
                } else if (name_upper[0] == 'S') {
                    // S register (32-bit float)
                    size_t s_index = std::stoul(name.substr(1));
                    uint32_t value = ParseUint32(val.AsString());
                    // Store with special key to indicate S register
                    config.expected_regs["S" + std::to_string(s_index)] = value;
                }
            }
        }
    }

    const JsonValue* set_regdata = root.Get("SetRegData");
    if (set_regdata && set_regdata->IsObject()) {
        for (const auto& [name, val] : set_regdata->AsObject()) {
            if (!val.IsString()) {
                continue;
            }
            std::string name_upper = name;
            for (auto& c : name_upper) c = std::toupper(c);
            if (name_upper[0] == 'R') {
                config.init_regs[name] = ParseUint32(val.AsString());
            } else if (name_upper == "SP") {
                config.init_regs["SP"] = ParseUint32(val.AsString());
            } else if (name_upper == "PC") {
                config.init_regs["PC"] = ParseUint32(val.AsString());
            } else if (name_upper == "LR") {
                config.init_regs["LR"] = ParseUint32(val.AsString());
            } else if (name_upper[0] == 'S') {
                size_t s_index = std::stoul(name.substr(1));
                uint32_t value = ParseUint32(val.AsString());
                config.init_regs["S" + std::to_string(s_index)] = value;
            }
        }
    }
    
    // Parse VecData
    const JsonValue* vecdata = root.Get("VecData");
    if (vecdata && vecdata->IsObject()) {
        for (const auto& [name, val] : vecdata->AsObject()) {
            std::string name_upper = name;
            for (auto& c : name_upper) c = std::toupper(c);
            
            if (name_upper[0] == 'D') {
                // D register (64-bit)
                if (val.IsString()) {
                    config.expected_dregs[name] = ParseUint64(val.AsString());
                } else if (val.IsArray() && val.AsArray().size() >= 1) {
                    config.expected_dregs[name] = ParseUint64(val.AsArray()[0].AsString());
                }
            } else if (name_upper[0] == 'Q') {
                // Q register (128-bit) - store as pair of uint64
                if (val.IsString()) {
                    std::string hex_str = val.AsString();
                    // Remove 0x prefix if present
                    if (hex_str.substr(0, 2) == "0x" || hex_str.substr(0, 2) == "0X") {
                        hex_str = hex_str.substr(2);
                    }
                    // Pad to 32 hex digits if needed
                    while (hex_str.length() < 32) {
                        hex_str = "0" + hex_str;
                    }
                    // The hex string is in big-endian format: high 64 bits first, then low 64 bits
                    // We need: low = last 16 hex digits, high = first 16 hex digits
                    std::string high_str = hex_str.substr(0, 16);  // First 16 = high 64 bits
                    std::string low_str = hex_str.substr(16, 16);  // Last 16 = low 64 bits
                    uint64_t high = std::stoull(high_str, nullptr, 16);
                    uint64_t low = std::stoull(low_str, nullptr, 16);
                    config.expected_qregs[name] = {low, high};
                } else if (val.IsArray() && val.AsArray().size() >= 2) {
                    uint64_t low = ParseUint64(val.AsArray()[0].AsString());
                    uint64_t high = ParseUint64(val.AsArray()[1].AsString());
                    config.expected_qregs[name] = {low, high};
                }
            }
        }
    }

    const JsonValue* set_vecdata = root.Get("SetVecData");
    if (set_vecdata && set_vecdata->IsObject()) {
        for (const auto& [name, val] : set_vecdata->AsObject()) {
            std::string name_upper = name;
            for (auto& c : name_upper) c = std::toupper(c);
            if (name_upper[0] == 'D') {
                if (val.IsString()) {
                    config.init_dregs[name] = ParseUint64(val.AsString());
                } else if (val.IsArray() && val.AsArray().size() >= 1) {
                    config.init_dregs[name] = ParseUint64(val.AsArray()[0].AsString());
                }
            } else if (name_upper[0] == 'Q') {
                if (val.IsString()) {
                    std::string hex_str = val.AsString();
                    if (hex_str.substr(0, 2) == "0x" || hex_str.substr(0, 2) == "0X") {
                        hex_str = hex_str.substr(2);
                    }
                    while (hex_str.length() < 32) {
                        hex_str = "0" + hex_str;
                    }
                    std::string high_str = hex_str.substr(0, 16);
                    std::string low_str = hex_str.substr(16, 16);
                    uint64_t high = std::stoull(high_str, nullptr, 16);
                    uint64_t low = std::stoull(low_str, nullptr, 16);
                    config.init_qregs[name] = {low, high};
                } else if (val.IsArray() && val.AsArray().size() >= 2) {
                    uint64_t low = ParseUint64(val.AsArray()[0].AsString());
                    uint64_t high = ParseUint64(val.AsArray()[1].AsString());
                    config.init_qregs[name] = {low, high};
                }
            }
        }
    }
    
    // Parse DataMem - initialize data memory at specific addresses
    const JsonValue* datamem = root.Get("DataMem");
    if (datamem && datamem->IsObject()) {
        for (const auto& [addr_str, val] : datamem->AsObject()) {
            uint32_t addr = ParseUint32(addr_str);
            std::vector<uint8_t> data;
            if (val.IsArray()) {
                for (const auto& item : val.AsArray()) {
                    if (item.IsString()) {
                        uint8_t byte = static_cast<uint8_t>(std::stoul(item.AsString(), nullptr, 0));
                        data.push_back(byte);
                    }
                }
            } else if (val.IsString()) {
                // Single hex string like "0x12345678"
                std::string hex_str = val.AsString();
                if (hex_str.substr(0, 2) == "0x" || hex_str.substr(0, 2) == "0X") {
                    hex_str = hex_str.substr(2);
                }
                // Convert hex string to bytes (little-endian)
                while (hex_str.length() % 2 != 0) {
                    hex_str = "0" + hex_str;
                }
                for (size_t i = 0; i < hex_str.length(); i += 2) {
                    uint8_t byte = static_cast<uint8_t>(std::stoul(hex_str.substr(hex_str.length() - 2 - i, 2), nullptr, 16));
                    data.push_back(byte);
                }
            }
            if (!data.empty()) {
                config.data_mem_init[addr] = data;
            }
        }
    }

    const JsonValue* expected_memdata = root.Get("ExpectedMemData");
    if (expected_memdata && expected_memdata->IsObject()) {
        for (const auto& [addr_str, val] : expected_memdata->AsObject()) {
            uint32_t addr = ParseUint32(addr_str);
            std::vector<uint8_t> data;
            if (val.IsArray()) {
                for (const auto& item : val.AsArray()) {
                    if (item.IsString()) {
                        uint8_t byte = static_cast<uint8_t>(std::stoul(item.AsString(), nullptr, 0));
                        data.push_back(byte);
                    }
                }
            } else if (val.IsString()) {
                std::string hex_str = val.AsString();
                if (hex_str.substr(0, 2) == "0x" || hex_str.substr(0, 2) == "0X") {
                    hex_str = hex_str.substr(2);
                }
                while (hex_str.length() % 2 != 0) {
                    hex_str = "0" + hex_str;
                }
                for (size_t i = 0; i < hex_str.length(); i += 2) {
                    uint8_t byte = static_cast<uint8_t>(std::stoul(hex_str.substr(hex_str.length() - 2 - i, 2), nullptr, 16));
                    data.push_back(byte);
                }
            }
            if (!data.empty()) {
                config.expected_mem_data[addr] = data;
            }
        }
    }

    // Parse TlsData - TLS memory initialization at offset from TLS base
    const JsonValue* tlsdata = root.Get("TlsData");
    if (tlsdata && tlsdata->IsObject()) {
        for (const auto& [addr_str, val] : tlsdata->AsObject()) {
            uint32_t addr = ParseUint32(addr_str);
            std::vector<uint8_t> data;
            if (val.IsArray()) {
                for (const auto& item : val.AsArray()) {
                    if (item.IsString()) {
                        const uint32_t word = ParseUint32(item.AsString());
                        for (size_t i = 0; i < sizeof(uint32_t); i++) {
                            data.push_back(static_cast<uint8_t>((word >> (i * 8)) & 0xFF));
                        }
                    }
                }
            } else if (val.IsString()) {
                std::string hex_str = val.AsString();
                if (hex_str.substr(0, 2) == "0x" || hex_str.substr(0, 2) == "0X") {
                    hex_str = hex_str.substr(2);
                }
                while (hex_str.length() % 2 != 0) {
                    hex_str = "0" + hex_str;
                }
                for (size_t i = 0; i < hex_str.length(); i += 2) {
                    uint8_t byte = static_cast<uint8_t>(
                        std::stoul(hex_str.substr(hex_str.length() - 2 - i, 2), nullptr, 16));
                    data.push_back(byte);
                }
            }
            if (!data.empty()) {
                config.tls_mem_init[addr] = data;
            }
        }
    }

    const JsonValue* tpidrurw_init = root.Get("TpidrurwInit");
    if (tpidrurw_init && tpidrurw_init->IsString()) {
        config.tpidrurw_init = ParseUint32(tpidrurw_init->AsString());
    }
    const JsonValue* tpidruro_init = root.Get("TpidruroInit");
    if (tpidruro_init && tpidruro_init->IsString()) {
        config.tpidruro_init = ParseUint32(tpidruro_init->AsString());
    }

    const JsonValue* svctest = root.Get("SvcTest");
    if (svctest && svctest->IsArray()) {
        for (const auto& action_val : svctest->AsArray()) {
            if (!action_val.IsObject()) {
                continue;
            }
            AsmTestConfig::SvcAction action;
            const auto& obj = action_val.AsObject();
            auto svc_it = obj.find("svc");
            if (svc_it != obj.end() && svc_it->second.IsString()) {
                action.svc_num = ParseUint32(svc_it->second.AsString());
            }
            auto action_it = obj.find("action");
            if (action_it != obj.end() && action_it->second.IsString()) {
                action.action = action_it->second.AsString();
            }
            auto offset_it = obj.find("offset");
            if (offset_it != obj.end() && offset_it->second.IsString()) {
                action.offset = ParseUint32(offset_it->second.AsString());
            }
            auto value_it = obj.find("value");
            if (value_it != obj.end() && value_it->second.IsString()) {
                action.value = ParseUint32(value_it->second.AsString());
            }
            auto reg_it = obj.find("result_reg");
            if (reg_it != obj.end() && reg_it->second.IsString()) {
                action.result_reg = reg_it->second.AsString();
            }
            config.svc_actions.push_back(action);
        }
    }
    
    config.valid = true;
    return config;
}

// ============================================================================
// Test Environment (handles BKPT as test end)
// ============================================================================

// Memory layout for testing:
// - 0x0000 - 0x0FFF: Code memory (code_mem)
// - 0x1000 - 0x1FFF: Data memory (data_mem) for LDR/STR testing
// - 0x2000 - 0x2FFF: Stack region (used by SP)
static constexpr u32 CODE_MEM_BASE = 0x0000;
static constexpr u32 CODE_MEM_SIZE = 0x1000;
static constexpr u32 DATA_MEM_BASE = 0x1000;
static constexpr u32 DATA_MEM_SIZE = 0x1000;
static constexpr u32 STACK_BASE = 0x2000;
static constexpr u32 STACK_SIZE = 0x1000;
static constexpr u32 TLS_MEM_BASE = 0x3000;
static constexpr u32 TLS_MEM_SIZE = 0x1000;

struct CP15State {
    u32 cp15_thread_uprw = TLS_MEM_BASE;
    u32 cp15_thread_uro = TLS_MEM_BASE;
    u32 cp15_mrrc_low = 0x80000001;
    u32 cp15_padding = 0xDEADBEEF;
    u32 cp15_mrrc_high = 0x12345678;
};

class TestCP15 final : public Dynarmic::A32::Coprocessor {
public:
    using CoprocReg = Dynarmic::A32::CoprocReg;
    using Callback = Dynarmic::A32::Coprocessor::Callback;
    using CallbackOrAccessOneWord = Dynarmic::A32::Coprocessor::CallbackOrAccessOneWord;
    using CallbackOrAccessTwoWords = Dynarmic::A32::Coprocessor::CallbackOrAccessTwoWords;

    explicit TestCP15(CP15State& state_)
            : state(state_) {}

    std::optional<Callback> CompileInternalOperation(bool, unsigned, CoprocReg, CoprocReg, CoprocReg, unsigned) override {
        return std::nullopt;
    }

    CallbackOrAccessOneWord CompileSendOneWord(bool two, unsigned opc1, CoprocReg CRn, CoprocReg CRm, unsigned opc2) override {
        if (!two && CRn == CoprocReg::C13 && opc1 == 0 && CRm == CoprocReg::C0 && opc2 == 2) {
            return &state.cp15_thread_uprw;
        }
        return std::monostate{};
    }

    CallbackOrAccessTwoWords CompileSendTwoWords(bool, unsigned, CoprocReg) override {
        return std::monostate{};
    }

    CallbackOrAccessOneWord CompileGetOneWord(bool two, unsigned opc1, CoprocReg CRn, CoprocReg CRm, unsigned opc2) override {
        if (!two && CRn == CoprocReg::C13 && opc1 == 0 && CRm == CoprocReg::C0) {
            switch (opc2) {
            case 2:
                return &state.cp15_thread_uprw;
            case 3:
                return &state.cp15_thread_uro;
            default:
                return std::monostate{};
            }
        }
        return std::monostate{};
    }

    CallbackOrAccessTwoWords CompileGetTwoWords(bool two, unsigned opc, CoprocReg CRm) override {
        if (!two && opc == 0 && CRm == CoprocReg::C0) {
            return std::array<u32*, 2>{&state.cp15_mrrc_low, &state.cp15_mrrc_high};
        }
        return std::monostate{};
    }

    std::optional<Callback> CompileLoadWords(bool, bool, CoprocReg, std::optional<u8>) override {
        return std::nullopt;
    }

    std::optional<Callback> CompileStoreWords(bool, bool, CoprocReg, std::optional<u8>) override {
        return std::nullopt;
    }

private:
    CP15State& state;
};

class A32AsmTestEnv : public Dynarmic::A32::UserCallbacks {
public:
    u64 ticks_left = 0;
    std::vector<u32> code_mem;
    std::vector<u8> data_mem;  // Data memory for LDR/STR testing
    std::vector<u8> tls_mem;   // TLS memory for TPIDRURW/URO based tests
    bool bkpt_hit = false;
    u32 bkpt_pc = 0;
    bool unexpected_exception = false;
    std::string unexpected_exception_message;
    Dynarmic::A32::Jit* jit = nullptr;  // Pointer to JIT for halting execution
    CP15State cp15_state;
    std::vector<AsmTestConfig::SvcAction> svc_actions;
    size_t svc_action_index = 0;

    A32AsmTestEnv() : data_mem(DATA_MEM_SIZE + STACK_SIZE, 0), tls_mem(TLS_MEM_SIZE, 0) {}
    
    std::optional<std::uint32_t> MemoryReadCode(u32 vaddr) override {
        const size_t index = vaddr / 4;
        if (index < code_mem.size()) {
            return code_mem[index];
        }
        return 0xE7FEE7FE;  // UDF #<imm>
    }
    
    std::uint8_t MemoryRead8(u32 vaddr) override {
        return ReadMemory<u8>(vaddr);
    }
    std::uint16_t MemoryRead16(u32 vaddr) override {
        return ReadMemory<u16>(vaddr);
    }
    std::uint32_t MemoryRead32(u32 vaddr) override { 
        // First check code memory
        const size_t index = vaddr / 4;
        if (vaddr >= CODE_MEM_BASE && vaddr < CODE_MEM_BASE + CODE_MEM_SIZE && index < code_mem.size()) {
            return code_mem[index];
        }
        return ReadMemory<u32>(vaddr);
    }
    std::uint64_t MemoryRead64(u32 vaddr) override {
        // First check code memory
        const size_t index = vaddr / 4;
        if (vaddr >= CODE_MEM_BASE && vaddr < CODE_MEM_BASE + CODE_MEM_SIZE && index + 1 < code_mem.size()) {
            u64 low = code_mem[index];
            u64 high = code_mem[index + 1];
            return (high << 32) | low;
        }
        return ReadMemory<u64>(vaddr);
    }
    
    void MemoryWrite8(u32 vaddr, std::uint8_t value) override {
        WriteMemory<u8>(vaddr, value);
    }
    void MemoryWrite16(u32 vaddr, std::uint16_t value) override {
        WriteMemory<u16>(vaddr, value);
    }
    void MemoryWrite32(u32 vaddr, std::uint32_t value) override {
        WriteMemory<u32>(vaddr, value);
    }
    void MemoryWrite64(u32 vaddr, std::uint64_t value) override {
        WriteMemory<u64>(vaddr, value);
    }
    
    bool MemoryWriteExclusive8(u32 vaddr, std::uint8_t value, std::uint8_t expected) override {
        return WriteMemoryExclusive<u8>(vaddr, value, expected);
    }
    bool MemoryWriteExclusive16(u32 vaddr, std::uint16_t value, std::uint16_t expected) override {
        return WriteMemoryExclusive<u16>(vaddr, value, expected);
    }
    bool MemoryWriteExclusive32(u32 vaddr, std::uint32_t value, std::uint32_t expected) override {
        return WriteMemoryExclusive<u32>(vaddr, value, expected);
    }
    bool MemoryWriteExclusive64(u32 vaddr, std::uint64_t value, std::uint64_t expected) override {
        return WriteMemoryExclusive<u64>(vaddr, value, expected);
    }
    
private:
    template<typename T>
    T ReadMemory(u32 vaddr) {
        // Map to data memory region
        size_t offset = 0;
        if (vaddr >= DATA_MEM_BASE && vaddr < DATA_MEM_BASE + DATA_MEM_SIZE) {
            offset = vaddr - DATA_MEM_BASE;
        } else if (vaddr >= STACK_BASE && vaddr < STACK_BASE + STACK_SIZE) {
            offset = DATA_MEM_SIZE + (vaddr - STACK_BASE);
        } else if (vaddr >= TLS_MEM_BASE && vaddr < TLS_MEM_BASE + TLS_MEM_SIZE) {
            offset = vaddr - TLS_MEM_BASE;
            if (offset + sizeof(T) > tls_mem.size()) {
                return 0;
            }
            T result = 0;
            std::memcpy(&result, &tls_mem[offset], sizeof(T));
            return result;
        } else {
            return 0;  // Unmapped region
        }
        
        if (offset + sizeof(T) > data_mem.size()) {
            return 0;
        }
        
        T result = 0;
        std::memcpy(&result, &data_mem[offset], sizeof(T));
        return result;
    }
    
    template<typename T>
    void WriteMemory(u32 vaddr, T value) {
        // Map to data memory region
        size_t offset = 0;
        if (vaddr >= DATA_MEM_BASE && vaddr < DATA_MEM_BASE + DATA_MEM_SIZE) {
            offset = vaddr - DATA_MEM_BASE;
        } else if (vaddr >= STACK_BASE && vaddr < STACK_BASE + STACK_SIZE) {
            offset = DATA_MEM_SIZE + (vaddr - STACK_BASE);
        } else if (vaddr >= TLS_MEM_BASE && vaddr < TLS_MEM_BASE + TLS_MEM_SIZE) {
            offset = vaddr - TLS_MEM_BASE;
            if (offset + sizeof(T) > tls_mem.size()) {
                return;
            }
            std::memcpy(&tls_mem[offset], &value, sizeof(T));
            return;
        } else {
            return;  // Unmapped region, ignore write
        }
        
        if (offset + sizeof(T) > data_mem.size()) {
            return;
        }
        
        std::memcpy(&data_mem[offset], &value, sizeof(T));
    }
    
    template<typename T>
    bool WriteMemoryExclusive(u32 vaddr, T value, T expected) {
        // Simple exclusive write - check expected and write if matches
        T current = ReadMemory<T>(vaddr);
        bool match = (current == expected);
        if (match) {
            WriteMemory<T>(vaddr, value);
            return true;
        }
        return false;
    }

    uint32_t ReadTls32(uint32_t offset) {
        if (offset + sizeof(uint32_t) > tls_mem.size()) {
            return 0;
        }
        uint32_t value = 0;
        std::memcpy(&value, &tls_mem[offset], sizeof(value));
        return value;
    }

    void WriteTls32(uint32_t offset, uint32_t value) {
        if (offset + sizeof(uint32_t) > tls_mem.size()) {
            return;
        }
        std::memcpy(&tls_mem[offset], &value, sizeof(value));
    }

    int GetRegIndex(const std::string& name) {
        std::string upper = name;
        for (auto& c : upper) {
            c = static_cast<char>(std::toupper(static_cast<unsigned char>(c)));
        }
        if (upper == "SP") {
            return 13;
        }
        if (upper == "LR") {
            return 14;
        }
        if (upper == "PC") {
            return 15;
        }
        if (upper.size() >= 2 && upper[0] == 'R') {
            int idx = std::stoi(upper.substr(1));
            if (idx >= 0 && idx < 16) {
                return idx;
            }
        }
        return -1;
    }

    void CallSVC(std::uint32_t swi) override {
        while (svc_action_index < svc_actions.size()) {
            const auto& action = svc_actions[svc_action_index++];
            if (action.svc_num != swi) {
                continue;
            }

            if (action.action == "read_tls") {
                if (jit) {
                    const uint32_t value = ReadTls32(action.offset);
                    const int reg = action.result_reg.empty() ? 0 : GetRegIndex(action.result_reg);
                    if (reg >= 0) {
                        switch (reg) {
                        case 13:
                            jit->Regs()[13] = value;
                            break;
                        case 14:
                            jit->Regs()[14] = value;
                            break;
                        case 15:
                            jit->Regs()[15] = value;
                            break;
                        default:
                            jit->Regs()[static_cast<size_t>(reg)] = value;
                            break;
                        }
                    }
                }
                return;
            }

            if (action.action == "write_tls") {
                if (jit) {
                    const int reg = action.result_reg.empty() ? 0 : GetRegIndex(action.result_reg);
                    const uint32_t value =
                        reg == 13 ? jit->Regs()[13] :
                        reg == 14 ? jit->Regs()[14] :
                        reg == 15 ? jit->Regs()[15] :
                        reg >= 0 ? jit->Regs()[static_cast<size_t>(reg)] :
                                   action.value;
                    WriteTls32(action.offset, value);
                } else {
                    WriteTls32(action.offset, action.value);
                }
                return;
            }

            if (action.action == "halt") {
                if (jit) {
                    jit->HaltExecution();
                }
                return;
            }
        }
        std::fprintf(stderr, "CallSVC({})\n", swi); std::abort();
    }
    
    void ExceptionRaised(u32 pc, Dynarmic::A32::Exception exception) override {
        if (exception == Dynarmic::A32::Exception::Breakpoint) {
            bkpt_hit = true;
            bkpt_pc = pc;
            // Halt execution so JIT doesn't continue to next block
            if (jit) {
                jit->HaltExecution();
            }
            return;  // Don't assert on BKPT, it's our test end marker
        }
        // Handle hint instructions that raise exceptions
        if (exception == Dynarmic::A32::Exception::Yield ||
            exception == Dynarmic::A32::Exception::WaitForEvent ||
            exception == Dynarmic::A32::Exception::WaitForInterrupt ||
            exception == Dynarmic::A32::Exception::SendEvent ||
            exception == Dynarmic::A32::Exception::SendEventLocal) {
            return;  // Just continue execution
        }
        unexpected_exception = true;
        unexpected_exception_message =
            fmt::format("ExceptionRaised({:08x}, {})", pc, static_cast<int>(exception));
        if (jit) {
            jit->HaltExecution(Dynarmic::HaltReason::UserDefined2);
        }
    }
    
    void AddTicks(std::uint64_t ticks) override {
        if (ticks > ticks_left) {
            ticks_left = 0;
            return;
        }
        ticks_left -= ticks;
    }
    
    std::uint64_t GetTicksRemaining() override {
        return ticks_left;
    }
};

// ============================================================================
// Assembly Compiler
// ============================================================================

bool CompileAsmToBinary(const std::string& asm_path, const std::string& bin_path) {
    // Create temp object file path
    std::string obj_path = asm_path + ".o";
    
    // Compile assembly to object file (ARM32 mode)
    // Use arm-none-eabi-as for ARM32 assembly
    // Default is ARM mode, use -mthumb for Thumb mode
    // Use cortex-a15 with NEON/VFPv4 support for SIMD instructions
    std::string cmd = "arm-none-eabi-as -mcpu=cortex-a15 -mfpu=neon-vfpv4 -o \"" + obj_path + "\" \"" + asm_path + "\" 2>&1";
    FILE* pipe = popen(cmd.c_str(), "r");
    if (!pipe) {
        return false;
    }
    
    char buffer[256];
    std::string output;
    while (fgets(buffer, sizeof(buffer), pipe)) {
        output += buffer;
    }
    int result = pclose(pipe);
    
    if (result != 0) {
        fmt::println(stderr, "Assembly failed:\n{}", output);
        return false;
    }
    
    // Extract binary from object file
    cmd = "arm-none-eabi-objcopy -O binary \"" + obj_path + "\" \"" + bin_path + "\" 2>&1";
    pipe = popen(cmd.c_str(), "r");
    if (!pipe) {
        unlink(obj_path.c_str());
        return false;
    }
    
    output.clear();
    while (fgets(buffer, sizeof(buffer), pipe)) {
        output += buffer;
    }
    result = pclose(pipe);
    
    unlink(obj_path.c_str());
    
    if (result != 0) {
        fmt::println(stderr, "Objcopy failed:\n{}", output);
        return false;
    }
    
    return true;
}

std::vector<u32> LoadBinary(const std::string& bin_path) {
    std::ifstream file(bin_path, std::ios::binary);
    if (!file) {
        return {};
    }
    
    // Get file size
    file.seekg(0, std::ios::end);
    size_t size = file.tellg();
    file.seekg(0, std::ios::beg);
    
    // Read as 32-bit words, preserving trailing halfword for Thumb binaries.
    std::vector<u32> code((size + 3) / 4, 0);
    file.read(reinterpret_cast<char*>(code.data()), static_cast<std::streamsize>(size));
    
    return code;
}

// ============================================================================
// Test File Parser
// ============================================================================

bool ParseAsmTestFile(const std::string& path, std::string& json_config) {
    std::ifstream file(path);
    if (!file) {
        return false;
    }
    
    // Read entire file
    std::string content((std::istreambuf_iterator<char>(file)),
                         std::istreambuf_iterator<char>());
    
    // Find /* CONFIG ... */
    size_t start = content.find("/*");
    if (start == std::string::npos) {
        return false;
    }
    
    // Check if it's a CONFIG block
    size_t config_pos = content.find("CONFIG", start);
    if (config_pos == std::string::npos || config_pos > start + 20) {
        return false;  // Not a CONFIG block
    }
    
    // Find the end of the block comment
    size_t end = content.find("*/", start + 2);
    if (end == std::string::npos) {
        return false;
    }
    
    // Extract content between /* and */
    std::string block = content.substr(start + 2, end - start - 2);
    
    // Remove CONFIG prefix
    size_t json_start = block.find('{');
    if (json_start == std::string::npos) {
        return false;
    }
    
    json_config = block.substr(json_start);
    
    return true;
}

// ============================================================================
// Test Runner
// ============================================================================

struct TestResult {
    bool passed = true;
    bool is_known_failure = false;
    std::string known_failure_reason;
    std::string error_msg;
    std::string test_name;
};

TestResult RunAsmTest(const std::string& asm_path) {
    TestResult result;
    result.test_name = fs::path(asm_path).stem().string();
    
    // Parse config from asm file
    std::string json_config;
    if (!ParseAsmTestFile(asm_path, json_config)) {
        result.passed = false;
        result.error_msg = "Failed to parse test file";
        return result;
    }
    
    AsmTestConfig config = ParseTestConfig(json_config);
    if (!config.valid) {
        result.passed = false;
        result.error_msg = "Failed to parse test config";
        return result;
    }
    
    // Check if this is a known failure
    if (!config.known_failure.empty()) {
        result.is_known_failure = true;
        result.known_failure_reason = config.known_failure;
    }
    
    // Create temp binary path
    std::string bin_path = asm_path + ".bin";
    
    // Compile assembly
    if (!CompileAsmToBinary(asm_path, bin_path)) {
        result.passed = false;
        result.error_msg = "Failed to compile assembly";
        return result;
    }
    
    // Load binary
    std::vector<u32> code = LoadBinary(bin_path);
    unlink(bin_path.c_str());
    
    if (code.empty()) {
        result.passed = false;
        result.error_msg = "Failed to load binary (empty?)";
        return result;
    }
    
    // Setup JIT
    A32AsmTestEnv env;
    env.code_mem = code;
    
    // Initialize data memory from config
    for (const auto& [addr, data] : config.data_mem_init) {
        size_t offset = 0;
        if (addr >= DATA_MEM_BASE && addr < DATA_MEM_BASE + DATA_MEM_SIZE) {
            offset = addr - DATA_MEM_BASE;
        } else if (addr >= STACK_BASE && addr < STACK_BASE + STACK_SIZE) {
            offset = DATA_MEM_SIZE + (addr - STACK_BASE);
        } else {
            continue;  // Unmapped address
        }
        if (offset + data.size() <= env.data_mem.size()) {
            std::memcpy(&env.data_mem[offset], data.data(), data.size());
        }
    }

    for (const auto& [addr, data] : config.tls_mem_init) {
        if (addr + data.size() <= env.tls_mem.size()) {
            std::memcpy(&env.tls_mem[addr], data.data(), data.size());
        }
    }
    env.cp15_state.cp15_thread_uprw = config.tpidrurw_init;
    env.cp15_state.cp15_thread_uro = config.tpidruro_init;
    env.svc_actions = config.svc_actions;
    
    // Create exclusive monitor for LDREX/STREX instructions
    Dynarmic::ExclusiveMonitor monitor{1};
    
    Dynarmic::A32::UserConfig jit_config;
    
    jit_config.callbacks = &env;
    jit_config.global_monitor = &monitor;
    jit_config.processor_id = 0;
    jit_config.coprocessors[15] = std::make_shared<TestCP15>(env.cp15_state);
    
    Dynarmic::A32::Jit jit{jit_config};
    
    env.jit = &jit;  // Set pointer so ExceptionRaised can halt execution
    
    jit.SetCpsr(config.init_cpsr);
    jit.Regs()[15] = 0;
    jit.Regs()[13] = STACK_BASE + STACK_SIZE / 2;
    jit.SetFpscr(config.init_fpscr);

    for (const auto& [name, value] : config.init_regs) {
        std::string name_upper = name;
        for (auto& c : name_upper) c = std::toupper(c);
        if (name_upper[0] == 'R') {
            size_t reg_index = std::stoul(name.substr(1));
            if (reg_index < 16) {
                jit.Regs()[reg_index] = value;
            }
        } else if (name_upper == "SP") {
            jit.Regs()[13] = value;
        } else if (name_upper == "LR") {
            jit.Regs()[14] = value;
        } else if (name_upper == "PC") {
            jit.Regs()[15] = value;
        } else if (name_upper[0] == 'S') {
            size_t s_index = std::stoul(name.substr(1));
            if (s_index < 64) {
                jit.ExtRegs()[s_index] = value;
            }
        }
    }

    for (const auto& [name, value] : config.init_dregs) {
        size_t reg_index = std::stoul(name.substr(1));
        if (reg_index < 32) {
            jit.ExtRegs()[reg_index * 2] = static_cast<u32>(value);
            jit.ExtRegs()[reg_index * 2 + 1] = static_cast<u32>(value >> 32);
        }
    }

    for (const auto& [name, value] : config.init_qregs) {
        size_t reg_index = std::stoul(name.substr(1));
        if (reg_index < 16) {
            jit.ExtRegs()[reg_index * 4] = static_cast<u32>(value.first);
            jit.ExtRegs()[reg_index * 4 + 1] = static_cast<u32>(value.first >> 32);
            jit.ExtRegs()[reg_index * 4 + 2] = static_cast<u32>(value.second);
            jit.ExtRegs()[reg_index * 4 + 3] = static_cast<u32>(value.second >> 32);
        }
    }
    
    // Run until BKPT or timeout
    env.ticks_left = config.max_ticks;
    try {
        jit.Run();
    } catch (const std::exception& e) {
        result.passed = false;
        result.error_msg = fmt::format("Unhandled exception: {}", e.what());
        return result;
    }

    if (env.unexpected_exception) {
        result.passed = false;
        result.error_msg = env.unexpected_exception_message;
        return result;
    }

    if (!env.bkpt_hit) {
        result.passed = false;
        result.error_msg = "Test did not hit BKPT instruction (timeout or error)";
        return result;
    }
    
    // Check expected values
    int errors = 0;
    
    // Check registers (R0-R15, SP, LR, PC)
    for (const auto& [name, expected] : config.expected_regs) {
        std::string name_upper = name;
        for (auto& c : name_upper) c = std::toupper(c);
        
        // Parse register name
        uint32_t actual = 0;
        
        if (name_upper[0] == 'R') {
            // R0-R15
            size_t reg_index = std::stoul(name.substr(1));
            if (reg_index < 16) {
                actual = jit.Regs()[reg_index];
                if (actual != expected) {
                    result.error_msg += fmt::format("{}: expected 0x{:08X}, got 0x{:08X}\n", 
                        name, expected, actual);
                    errors++;
                }
            }
        } else if (name_upper == "SP") {
            actual = jit.Regs()[13];
            if (actual != expected) {
                result.error_msg += fmt::format("SP: expected 0x{:08X}, got 0x{:08X}\n", 
                    expected, actual);
                errors++;
            }
        } else if (name_upper == "LR") {
            actual = jit.Regs()[14];
            if (actual != expected) {
                result.error_msg += fmt::format("LR: expected 0x{:08X}, got 0x{:08X}\n", 
                    expected, actual);
                errors++;
            }
        } else if (name_upper == "PC") {
            actual = jit.Regs()[15];
            if (actual != expected) {
                result.error_msg += fmt::format("PC: expected 0x{:08X}, got 0x{:08X}\n", 
                    expected, actual);
                errors++;
            }
        } else if (name_upper[0] == 'S') {
            // S register (32-bit float, part of ExtRegs)
            size_t s_index = std::stoul(name.substr(1));
            if (s_index < 64) {
                actual = jit.ExtRegs()[s_index];
                if (actual != expected) {
                    result.error_msg += fmt::format("S{}: expected 0x{:08X}, got 0x{:08X}\n", 
                        s_index, expected, actual);
                    errors++;
                }
            }
        }
    }

    if (config.has_expected_cpsr) {
        const uint32_t actual = jit.Cpsr();
        if (actual != config.expected_cpsr) {
            result.error_msg += fmt::format("CPSR: expected 0x{:08X}, got 0x{:08X}\n",
                config.expected_cpsr, actual);
            errors++;
        }
    }

    if (config.has_expected_fpscr) {
        const uint32_t actual = jit.Fpscr();
        if (actual != config.expected_fpscr) {
            result.error_msg += fmt::format("FPSCR: expected 0x{:08X}, got 0x{:08X}\n",
                config.expected_fpscr, actual);
            errors++;
        }
    }
    
    // Check D registers (64-bit)
    for (const auto& [name, expected] : config.expected_dregs) {
        // Parse D register name (D0-D31)
        size_t reg_index = std::stoul(name.substr(1));
        if (reg_index < 32) {
            // D register is composed of two consecutive S registers
            // Dn = S(2n+1):S(2n)
            uint64_t actual_low = jit.ExtRegs()[reg_index * 2];
            uint64_t actual_high = jit.ExtRegs()[reg_index * 2 + 1];
            uint64_t actual = actual_low | (actual_high << 32);
            
            if (actual != expected) {
                result.error_msg += fmt::format("{}: expected 0x{:016X}, got 0x{:016X}\n", 
                    name, expected, actual);
                errors++;
            }
        }
    }
    
    // Check Q registers (128-bit)
    for (const auto& [name, expected] : config.expected_qregs) {
        // Parse Q register name (Q0-Q15)
        size_t reg_index = std::stoul(name.substr(1));
        if (reg_index < 16) {
            // Q register is composed of four consecutive S registers
            // Qn = D(2n+1):D(2n) = S(4n+3):S(4n+2):S(4n+1):S(4n)
            uint64_t actual_low_low = jit.ExtRegs()[reg_index * 4];
            uint64_t actual_low_high = jit.ExtRegs()[reg_index * 4 + 1];
            uint64_t actual_high_low = jit.ExtRegs()[reg_index * 4 + 2];
            uint64_t actual_high_high = jit.ExtRegs()[reg_index * 4 + 3];
            
            uint64_t actual_low = actual_low_low | (actual_low_high << 32);
            uint64_t actual_high = actual_high_low | (actual_high_high << 32);
            
            if (actual_low != expected.first || actual_high != expected.second) {
                result.error_msg += fmt::format("{}: expected [0x{:016X}, 0x{:016X}], got [0x{:016X}, 0x{:016X}]\n", 
                    name, expected.first, expected.second, actual_low, actual_high);
                errors++;
            }
        }
    }

    for (const auto& [addr, expected_data] : config.expected_mem_data) {
        for (size_t i = 0; i < expected_data.size(); i++) {
            const uint8_t actual = env.MemoryRead8(addr + static_cast<uint32_t>(i));
            if (actual != expected_data[i]) {
                result.error_msg += fmt::format("MEM[0x{:08X}]: expected 0x{:02X}, got 0x{:02X}\n",
                    addr + static_cast<uint32_t>(i), expected_data[i], actual);
                errors++;
            }
        }
    }
    
    if (errors > 0) {
        result.passed = false;
        result.error_msg = fmt::format("{} errors:\n{}", errors, result.error_msg);
    }
    
    return result;
}

// ============================================================================
// Main
// ============================================================================

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fmt::println(stderr, "Usage: {} <test.s|test_directory>", argv[0]);
        fmt::println(stderr, "  Run ARM32 assembly tests through dynarmic JIT");
        return 1;
    }
    
    std::string input_path = argv[1];
    std::vector<std::string> test_files;
    std::string base_path;
    
    // Check if input is a file or directory
    if (fs::is_regular_file(input_path)) {
        // Single file mode
        test_files.push_back(input_path);
        base_path = fs::path(input_path).parent_path().string();
    } else if (fs::is_directory(input_path)) {
        // Directory mode - find all .s files recursively
        base_path = input_path;
        for (const auto& entry : fs::recursive_directory_iterator(input_path)) {
            if (entry.path().extension() == ".s" || entry.path().extension() == ".asm") {
                test_files.push_back(entry.path().string());
            }
        }
    } else {
        fmt::println(stderr, "Error: {} is not a valid file or directory", input_path);
        return 1;
    }
    
    fmt::println("A32 ASM Test Runner (dynarmic)");
    fmt::println("Input: {}", input_path);
    fmt::println("");
    
    if (test_files.empty()) {
        fmt::println(stderr, "No test files found");
        return 1;
    }
    
    // Sort tests by path
    std::sort(test_files.begin(), test_files.end());
    
    if (test_files.size() > 1) {
        fmt::println("Found {} test files", test_files.size());
        fmt::println("");
    }
    
    // Run tests
    int passed = 0;
    int failed = 0;
    int known_failures = 0;
    
    for (const auto& test_file : test_files) {
        std::string relative_path = fs::relative(test_file, base_path).string();
        fmt::print("Testing: {:<50} ... ", relative_path);
        fflush(stdout);
        
        TestResult result;
        try {
            result = RunAsmTest(test_file);
        } catch (const std::exception& e) {
            result.test_name = fs::path(test_file).stem().string();
            result.passed = false;
            result.error_msg = fmt::format("Unhandled exception: {}", e.what());
        } catch (...) {
            result.test_name = fs::path(test_file).stem().string();
            result.passed = false;
            result.error_msg = "Unhandled non-standard exception";
        }
        
        if (result.passed) {
            fmt::println("\033[32mPASSED\033[0m");
            passed++;
        } else if (result.is_known_failure) {
            fmt::println("\033[33mKNOWN FAILURE\033[0m");
            known_failures++;
            fmt::println("  \033[33mReason: {}\033[0m", result.known_failure_reason);
        } else {
            fmt::println("\033[31mFAILED\033[0m");
            failed++;
            fmt::println("  {}", result.error_msg);
        }
    }
    
    // Summary
    fmt::println("");
    fmt::println("==================================================");
    fmt::println("Summary: {} passed, {} failed, {} known failures", passed, failed, known_failures);
    
    return failed > 0 ? 1 : 0;
}
