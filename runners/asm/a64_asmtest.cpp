/* This file is part of the dynarmic project.
 * Copyright (c) 2024 dynarmic contributors
 * SPDX-License-Identifier: 0BSD
 * 
 * LoongArch64 port: Assembly-based testing framework
 * 
 * This is a standalone test program that compiles and runs AArch64 assembly tests.
 * Each test is defined in a .s file with a JSON config block in a C-style comment.
 * 
 * Usage: asmtest [test_directory]
 * 
 * Test file format (.s files):
 * 
 *   / * CONFIG
 *   {
 *     "Match": "All",
 *     "RegData": {
 *       "X0": "0x000000000000002A",
 *       "X1": "0x0000000000000032"
 *     },
 *     "VecData": {
 *       "V0": ["0x0000000100000001", "0x0000000100000001"]
 *     }
 *   }
 *   * /
 *   
 *   .text
 *   .global _start
 *   _start:
 *       mov x0, #42
 *       add x1, x0, #8
 *       brk #0   // Test end marker
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
#include <sstream>
#include <string>
#include <vector>

#include <fmt/format.h>
#include <cassert>

using u8 = std::uint8_t;
using u16 = std::uint16_t;
using u32 = std::uint32_t;
using u64 = std::uint64_t;

#include "dynarmic/interface/A64/a64.h"
#include "dynarmic/interface/exclusive_monitor.h"
#include "dynarmic/interface/halt_reason.h"

using Vector = Dynarmic::A64::Vector;

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

// SVC test action for TLS/SVC interaction testing
struct SvcAction {
    uint32_t svc_num;       // SVC number to handle
    std::string action;     // "read_tls", "write_tls", "verify_layout", "halt"
    uint64_t offset = 0;    // TLS offset
    uint64_t value = 0;     // Value to write or compare
    std::string result_reg; // Register to store result (e.g., "X0")
};

struct AsmTestConfig {
    std::string match_mode = "All";
    std::string known_failure;  // If set, test is expected to fail with this reason
    std::string bucket;
    std::string source_repro;
    std::map<std::string, uint64_t> init_regs;      // Initial register values (from SetRegData or legacy RegData)
    std::map<std::string, uint64_t> expected_regs;  // Expected register values (from RegData or ExpectedRegData)
    std::map<std::string, std::pair<uint64_t, uint64_t>> init_vecs;      // Initial vector values (from SetVecData or legacy VecData)
    std::map<std::string, std::pair<uint64_t, uint64_t>> expected_vecs;  // Expected vector values
    // MemData: address -> list of 64-bit values
    std::map<uint64_t, std::vector<uint64_t>> mem_data;
    std::map<uint64_t, std::vector<uint64_t>> expected_mem_data;

    uint32_t init_pstate = 0x40000000;
    uint32_t expected_pstate = 0;
    bool has_expected_pstate = false;
    uint32_t init_fpcr = 0;
    uint32_t expected_fpcr = 0;
    bool has_expected_fpcr = false;
    uint32_t init_fpsr = 0;
    uint32_t expected_fpsr = 0;
    bool has_expected_fpsr = false;
    uint64_t max_ticks = 10000;

    // TLS testing support
    uint64_t tpidr_el0_init = 0;    // Initial TPIDR_EL0 value (TLS base address)
    uint64_t tpidrro_el0_init = 0;  // Initial TPIDRRO_EL0 value (read-only TLS base)
    bool has_tpidr_el0_init = false;
    bool has_tpidrro_el0_init = false;
    std::map<uint64_t, std::vector<uint64_t>> tls_data;  // TLS memory initialization

    // SVC test actions
    std::vector<SvcAction> svc_actions;

    bool valid = false;
};

uint64_t ParseUint64(const std::string& s) {
    // Handle 128-bit hex strings (32 hex digits)
    if (s.length() > 18) {
        // This is a 128-bit value, parse as full 64-bit
        return std::stoull(s, nullptr, 0);
    }
    return std::stoull(s, nullptr, 0);
}

static std::vector<uint64_t> ParseUint64List(const JsonValue& val) {
    std::vector<uint64_t> values;

    if (val.IsString()) {
        values.push_back(ParseUint64(val.AsString()));
        return values;
    }

    if (val.IsArray()) {
        for (const auto& item : val.AsArray()) {
            if (item.IsString()) {
                values.push_back(ParseUint64(item.AsString()));
            }
        }
    }

    return values;
}

static std::optional<std::pair<uint64_t, uint64_t>> ParseVecPair(const JsonValue& val) {
    if (val.IsArray() && val.AsArray().size() >= 2) {
        const uint64_t low = ParseUint64(val.AsArray()[0].AsString());
        const uint64_t high = ParseUint64(val.AsArray()[1].AsString());
        return std::pair<uint64_t, uint64_t>{low, high};
    }

    if (val.IsString()) {
        std::string hex_str = val.AsString();
        if (hex_str.substr(0, 2) == "0x" || hex_str.substr(0, 2) == "0X") {
            hex_str = hex_str.substr(2);
        }
        while (hex_str.length() < 32) {
            hex_str = "0" + hex_str;
        }
        const std::string high_str = hex_str.substr(0, 16);
        const std::string low_str = hex_str.substr(16, 16);
        const uint64_t high = std::stoull(high_str, nullptr, 16);
        const uint64_t low = std::stoull(low_str, nullptr, 16);
        return std::pair<uint64_t, uint64_t>{low, high};
    }

    return std::nullopt;
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

    const JsonValue* set_pstate = root.Get("SetPstate");
    if (set_pstate && set_pstate->IsString()) {
        config.init_pstate = static_cast<uint32_t>(ParseUint64(set_pstate->AsString()));
    }

    const JsonValue* expected_pstate = root.Get("ExpectedPstate");
    if (expected_pstate && expected_pstate->IsString()) {
        config.expected_pstate = static_cast<uint32_t>(ParseUint64(expected_pstate->AsString()));
        config.has_expected_pstate = true;
    }

    const JsonValue* set_fpcr = root.Get("SetFpcr");
    if (set_fpcr && set_fpcr->IsString()) {
        config.init_fpcr = static_cast<uint32_t>(ParseUint64(set_fpcr->AsString()));
    }

    const JsonValue* expected_fpcr = root.Get("ExpectedFpcr");
    if (expected_fpcr && expected_fpcr->IsString()) {
        config.expected_fpcr = static_cast<uint32_t>(ParseUint64(expected_fpcr->AsString()));
        config.has_expected_fpcr = true;
    }

    const JsonValue* set_fpsr = root.Get("SetFpsr");
    if (set_fpsr && set_fpsr->IsString()) {
        config.init_fpsr = static_cast<uint32_t>(ParseUint64(set_fpsr->AsString()));
    }

    const JsonValue* expected_fpsr = root.Get("ExpectedFpsr");
    if (expected_fpsr && expected_fpsr->IsString()) {
        config.expected_fpsr = static_cast<uint32_t>(ParseUint64(expected_fpsr->AsString()));
        config.has_expected_fpsr = true;
    }

    const JsonValue* max_ticks = root.Get("MaxTicks");
    if (max_ticks && max_ticks->IsString()) {
        config.max_ticks = ParseUint64(max_ticks->AsString());
    }

    // Parse RegData (legacy: initial + expected, new-style: expected only)
    const JsonValue* regdata = root.Get("RegData");
    if (regdata && regdata->IsObject()) {
        for (const auto& [name, val] : regdata->AsObject()) {
            if (val.IsString()) {
                std::string name_upper = name;
                for (auto& c : name_upper) c = std::toupper(c);
                
                // Q register requires 128-bit parsing
                if (name_upper[0] == 'Q') {
                    if (const auto parsed = ParseVecPair(val)) {
                        const std::string vname = "V" + name.substr(1);
                        config.init_vecs[vname] = *parsed;
                        config.expected_vecs[vname] = *parsed;
                    }
                } else {
                    config.init_regs[name] = ParseUint64(val.AsString());
                    config.expected_regs[name] = config.init_regs[name];  // Default expected = init
                }
            }
        }
    }
    
    // Parse VecData (legacy: initial + expected, new-style: expected only)
    const JsonValue* vecdata = root.Get("VecData");
    if (vecdata && vecdata->IsObject()) {
        for (const auto& [name, val] : vecdata->AsObject()) {
            if (const auto parsed = ParseVecPair(val)) {
                config.init_vecs[name] = *parsed;
                config.expected_vecs[name] = *parsed;  // Default expected = init
            }
        }
    }

    // Parse SetRegData - explicit initial register values for new tests
    const JsonValue* set_regdata = root.Get("SetRegData");
    if (set_regdata && set_regdata->IsObject()) {
        for (const auto& [name, val] : set_regdata->AsObject()) {
            if (val.IsString()) {
                config.init_regs[name] = ParseUint64(val.AsString());
            }
        }
    }

    // Parse SetVecData - explicit initial vector values for new tests
    const JsonValue* set_vecdata = root.Get("SetVecData");
    if (set_vecdata && set_vecdata->IsObject()) {
        for (const auto& [name, val] : set_vecdata->AsObject()) {
            if (const auto parsed = ParseVecPair(val)) {
                config.init_vecs[name] = *parsed;
            }
        }
    }
    
    // Parse ExpectedRegData (overrides expected values)
    const JsonValue* expected_regdata = root.Get("ExpectedRegData");
    if (expected_regdata && expected_regdata->IsObject()) {
        for (const auto& [name, val] : expected_regdata->AsObject()) {
            if (val.IsString()) {
                config.expected_regs[name] = ParseUint64(val.AsString());
            }
        }
    }
    
    // Parse ExpectedVecData (overrides expected vector values)
    const JsonValue* expected_vecdata = root.Get("ExpectedVecData");
    if (expected_vecdata && expected_vecdata->IsObject()) {
        for (const auto& [name, val] : expected_vecdata->AsObject()) {
            if (val.IsArray() && val.AsArray().size() >= 2) {
                uint64_t low = ParseUint64(val.AsArray()[0].AsString());
                uint64_t high = ParseUint64(val.AsArray()[1].AsString());
                config.expected_vecs[name] = {low, high};
            }
        }
    }
    
    // Parse MemData
    const JsonValue* memdata = root.Get("MemData");
    if (memdata && memdata->IsObject()) {
        for (const auto& [addr_str, val] : memdata->AsObject()) {
            uint64_t addr = ParseUint64(addr_str);
            const std::vector<uint64_t> values = ParseUint64List(val);
            if (!values.empty()) {
                config.mem_data[addr] = values;
            }
        }
    }

    // Parse ExpectedMemData
    const JsonValue* expected_memdata = root.Get("ExpectedMemData");
    if (expected_memdata && expected_memdata->IsObject()) {
        for (const auto& [addr_str, val] : expected_memdata->AsObject()) {
            uint64_t addr = ParseUint64(addr_str);
            const std::vector<uint64_t> values = ParseUint64List(val);
            if (!values.empty()) {
                config.expected_mem_data[addr] = values;
            }
        }
    }

    // Parse TlsData - TLS memory initialization
    const JsonValue* tlsdata = root.Get("TlsData");
    if (tlsdata && tlsdata->IsObject()) {
        for (const auto& [addr_str, val] : tlsdata->AsObject()) {
            uint64_t addr = ParseUint64(addr_str);
            const std::vector<uint64_t> values = ParseUint64List(val);
            if (!values.empty()) {
                config.tls_data[addr] = values;
            }
        }
    }
    
    // Parse TpidrInit - initial TPIDR_EL0 value
    const JsonValue* tpidr_init = root.Get("TpidrInit");
    if (tpidr_init && tpidr_init->IsString()) {
        config.tpidr_el0_init = ParseUint64(tpidr_init->AsString());
        config.has_tpidr_el0_init = true;
    }

    // Parse TpidrroInit - initial TPIDRRO_EL0 value
    const JsonValue* tpidrro_init = root.Get("TpidrroInit");
    if (tpidrro_init && tpidrro_init->IsString()) {
        config.tpidrro_el0_init = ParseUint64(tpidrro_init->AsString());
        config.has_tpidrro_el0_init = true;
    }
    
    // Parse SvcTest - SVC action definitions
    const JsonValue* svctest = root.Get("SvcTest");
    if (svctest && svctest->IsArray()) {
        for (const auto& action_val : svctest->AsArray()) {
            if (!action_val.IsObject()) continue;
            const auto& obj = action_val.AsObject();
            
            SvcAction action;
            
            // Parse svc number
            auto svc_it = obj.find("svc");
            if (svc_it != obj.end() && svc_it->second.IsString()) {
                action.svc_num = static_cast<uint32_t>(ParseUint64(svc_it->second.AsString()));
            }
            
            // Parse action type
            auto action_it = obj.find("action");
            if (action_it != obj.end() && action_it->second.IsString()) {
                action.action = action_it->second.AsString();
            }
            
            // Parse offset
            auto offset_it = obj.find("offset");
            if (offset_it != obj.end() && offset_it->second.IsString()) {
                action.offset = ParseUint64(offset_it->second.AsString());
            }
            
            // Parse value
            auto value_it = obj.find("value");
            if (value_it != obj.end() && value_it->second.IsString()) {
                action.value = ParseUint64(value_it->second.AsString());
            }
            
            // Parse result register
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
// Test Environment (handles BRK as test end)
// ============================================================================

// Memory layout for testing:
// - 0x0000 - 0x0FFF: Code memory (code_mem)
// - 0x1000 - 0x1FFF: Data memory (data_mem) for LDR/STR testing
// - 0x2000 - 0x2FFF: Stack region (used by SP)
static constexpr u64 CODE_MEM_BASE = 0x0000;
static constexpr u64 CODE_MEM_SIZE = 0x1000;
static constexpr u64 DATA_MEM_BASE = 0x1000;
static constexpr u64 DATA_MEM_SIZE = 0x1000;
static constexpr u64 STACK_BASE = 0x2000;
static constexpr u64 STACK_SIZE = 0x1000;

// TLS memory region
static constexpr u64 TLS_MEM_BASE = 0x3000;
static constexpr u64 TLS_MEM_SIZE = 0x1000;

// Fastmem arena size (must cover all memory regions)
static constexpr u64 FASTMEM_ARENA_SIZE = 0x10000;  // 64KB

class AsmTestEnv : public Dynarmic::A64::UserCallbacks {
public:
    u64 ticks_left = 0;
    std::vector<u32> code_mem;
    std::vector<u8> data_mem;  // Data memory for LDR/STR testing
    std::map<u64, u8> extra_mem;  // Extra memory for arbitrary addresses (MemData)
    bool brk_hit = false;
    u64 brk_pc = 0;
    bool unexpected_exception = false;
    std::string unexpected_exception_message;
    Dynarmic::A64::Jit* jit = nullptr;  // Pointer to JIT for halting execution
    
    // TLS storage
    u64 tpidr_el0 = TLS_MEM_BASE;   // TPIDR_EL0 - writable TLS base
    u64 tpidrro_el0 = 0;            // TPIDRRO_EL0 - read-only TLS base
    std::vector<u8> tls_mem;        // TLS memory region
    
    // SVC test support
    std::vector<SvcAction> svc_actions;
    size_t svc_action_index = 0;
    
    // Fastmem support
    char* fastmem_arena = nullptr;
    
    AsmTestEnv() : data_mem(DATA_MEM_SIZE + STACK_SIZE, 0), tls_mem(TLS_MEM_SIZE, 0) {
        // Allocate fastmem arena
        fastmem_arena = static_cast<char*>(std::aligned_alloc(0x1000, FASTMEM_ARENA_SIZE));
        if (fastmem_arena) {
            std::memset(fastmem_arena, 0, FASTMEM_ARENA_SIZE);
        }
    }
    
    ~AsmTestEnv() {
        if (fastmem_arena) {
            std::free(fastmem_arena);
        }
    }
    
    // Sync code memory to fastmem arena
    void SyncCodeToFastmem() {
        if (fastmem_arena && !code_mem.empty()) {
            std::memcpy(fastmem_arena + CODE_MEM_BASE, code_mem.data(), 
                       std::min(code_mem.size() * 4, CODE_MEM_SIZE));
        }
    }
    
    // Sync data memory to fastmem arena
    void SyncDataToFastmem() {
        if (fastmem_arena) {
            std::memcpy(fastmem_arena + DATA_MEM_BASE, data_mem.data(), DATA_MEM_SIZE);
            std::memcpy(fastmem_arena + STACK_BASE, data_mem.data() + DATA_MEM_SIZE, STACK_SIZE);
            std::memcpy(fastmem_arena + TLS_MEM_BASE, tls_mem.data(), TLS_MEM_SIZE);
        }
    }
    
    // Sync fastmem arena back to data_mem (for verification)
    void SyncFastmemToData() {
        if (fastmem_arena) {
            std::memcpy(data_mem.data(), fastmem_arena + DATA_MEM_BASE, DATA_MEM_SIZE);
            std::memcpy(data_mem.data() + DATA_MEM_SIZE, fastmem_arena + STACK_BASE, STACK_SIZE);
            std::memcpy(tls_mem.data(), fastmem_arena + TLS_MEM_BASE, TLS_MEM_SIZE);
        }
    }
    
    std::optional<std::uint32_t> MemoryReadCode(u64 vaddr) override {
        const size_t index = vaddr / 4;
        if (index < code_mem.size()) {
            return code_mem[index];
        }
        return 0x14000000;  // B .
    }
    
    std::uint8_t MemoryRead8(u64 vaddr) override {
        return ReadMemory<u8>(vaddr);
    }
    std::uint16_t MemoryRead16(u64 vaddr) override {
        return ReadMemory<u16>(vaddr);
    }
    std::uint32_t MemoryRead32(u64 vaddr) override { 
        // First check code memory
        const size_t index = vaddr / 4;
        if (vaddr >= CODE_MEM_BASE && vaddr < CODE_MEM_BASE + CODE_MEM_SIZE && index < code_mem.size()) {
            return code_mem[index];
        }
        return ReadMemory<u32>(vaddr);
    }
    std::uint64_t MemoryRead64(u64 vaddr) override {
        // First check code memory
        const size_t index = vaddr / 4;
        if (vaddr >= CODE_MEM_BASE && vaddr < CODE_MEM_BASE + CODE_MEM_SIZE && index + 1 < code_mem.size()) {
            u64 low = code_mem[index];
            u64 high = code_mem[index + 1];
            return (high << 32) | low;
        }
        return ReadMemory<u64>(vaddr);
    }
    Vector MemoryRead128(u64 vaddr) override {
        Vector result = {0, 0};
        const size_t index = vaddr / 4;
        if (vaddr >= CODE_MEM_BASE && vaddr < CODE_MEM_BASE + CODE_MEM_SIZE && index + 3 < code_mem.size()) {
            result[0] = (static_cast<u64>(code_mem[index + 1]) << 32) | code_mem[index];
            result[1] = (static_cast<u64>(code_mem[index + 3]) << 32) | code_mem[index + 2];
            return result;
        }
        if (TryReadFastmem128(vaddr, result)) {
            return result;
        }
        // Read from data memory
        result[0] = ReadMemory<u64>(vaddr);
        result[1] = ReadMemory<u64>(vaddr + 8);
        return result;
    }
    
    void MemoryWrite8(u64 vaddr, std::uint8_t value) override {
        WriteMemory<u8>(vaddr, value);
    }
    void MemoryWrite16(u64 vaddr, std::uint16_t value) override {
        WriteMemory<u16>(vaddr, value);
    }
    void MemoryWrite32(u64 vaddr, std::uint32_t value) override {
        WriteMemory<u32>(vaddr, value);
    }
    void MemoryWrite64(u64 vaddr, std::uint64_t value) override {
        WriteMemory<u64>(vaddr, value);
    }
    void MemoryWrite128(u64 vaddr, Vector value) override {
        TryWriteFastmem128(vaddr, value);
        WriteMemory<u64>(vaddr, value[0]);
        WriteMemory<u64>(vaddr + 8, value[1]);
    }
    
    bool MemoryWriteExclusive8(u64 vaddr, std::uint8_t value, std::uint8_t expected) override {
        return WriteMemoryExclusive<u8>(vaddr, value, expected);
    }
    bool MemoryWriteExclusive16(u64 vaddr, std::uint16_t value, std::uint16_t expected) override {
        return WriteMemoryExclusive<u16>(vaddr, value, expected);
    }
    bool MemoryWriteExclusive32(u64 vaddr, std::uint32_t value, std::uint32_t expected) override {
        return WriteMemoryExclusive<u32>(vaddr, value, expected);
    }
    bool MemoryWriteExclusive64(u64 vaddr, std::uint64_t value, std::uint64_t expected) override {
        return WriteMemoryExclusive<u64>(vaddr, value, expected);
    }
    bool MemoryWriteExclusive128(u64 vaddr, Vector value, Vector expected) override {
        if (MemoryRead128(vaddr) == expected) {
            MemoryWrite128(vaddr, value);
            return true;
        }
        return false;
    }
    
    // Public method for initializing memory from test config
    void WriteMemory64(u64 vaddr, u64 value) {
        WriteMemory<u64>(vaddr, value);
    }

    u64 ReadMemory64(u64 vaddr) {
        return ReadMemory<u64>(vaddr);
    }

private:
    bool TryReadFastmem128(u64 vaddr, Vector& result) const {
        if (!fastmem_arena) {
            return false;
        }

        if (vaddr >= DATA_MEM_BASE && vaddr + sizeof(Vector) <= DATA_MEM_BASE + DATA_MEM_SIZE) {
            std::memcpy(&result, fastmem_arena + vaddr, sizeof(Vector));
            return true;
        }
        if (vaddr >= STACK_BASE && vaddr + sizeof(Vector) <= STACK_BASE + STACK_SIZE) {
            std::memcpy(&result, fastmem_arena + vaddr, sizeof(Vector));
            return true;
        }
        if (vaddr >= TLS_MEM_BASE && vaddr + sizeof(Vector) <= TLS_MEM_BASE + TLS_MEM_SIZE) {
            std::memcpy(&result, fastmem_arena + vaddr, sizeof(Vector));
            return true;
        }
        return false;
    }

    bool TryWriteFastmem128(u64 vaddr, const Vector& value) {
        if (!fastmem_arena) {
            return false;
        }

        if (vaddr >= DATA_MEM_BASE && vaddr + sizeof(Vector) <= DATA_MEM_BASE + DATA_MEM_SIZE) {
            std::memcpy(fastmem_arena + vaddr, &value, sizeof(Vector));
            return true;
        }
        if (vaddr >= STACK_BASE && vaddr + sizeof(Vector) <= STACK_BASE + STACK_SIZE) {
            std::memcpy(fastmem_arena + vaddr, &value, sizeof(Vector));
            return true;
        }
        if (vaddr >= TLS_MEM_BASE && vaddr + sizeof(Vector) <= TLS_MEM_BASE + TLS_MEM_SIZE) {
            std::memcpy(fastmem_arena + vaddr, &value, sizeof(Vector));
            return true;
        }
        return false;
    }

    void WriteFastmemBytes(u64 vaddr, const void* value, size_t size) {
        if (!fastmem_arena || vaddr + size > FASTMEM_ARENA_SIZE) {
            return;
        }
        std::memcpy(fastmem_arena + vaddr, value, size);
    }

    template<typename T>
    T ReadMemory(u64 vaddr) {
        // Map to data memory region
        size_t offset = 0;
        if (vaddr >= DATA_MEM_BASE && vaddr < DATA_MEM_BASE + DATA_MEM_SIZE) {
            offset = vaddr - DATA_MEM_BASE;
        } else if (vaddr >= STACK_BASE && vaddr < STACK_BASE + STACK_SIZE) {
            offset = DATA_MEM_SIZE + (vaddr - STACK_BASE);
        } else if (vaddr >= TLS_MEM_BASE && vaddr < TLS_MEM_BASE + TLS_MEM_SIZE) {
            // TLS memory region
            offset = vaddr - TLS_MEM_BASE;
            if (offset + sizeof(T) > tls_mem.size()) {
                return 0;
            }
            T result = 0;
            std::memcpy(&result, &tls_mem[offset], sizeof(T));
            return result;
        } else {
            // Check extra_mem for arbitrary addresses
            T result = 0;
            for (size_t i = 0; i < sizeof(T); i++) {
                auto it = extra_mem.find(vaddr + i);
                if (it != extra_mem.end()) {
                    result |= static_cast<T>(it->second) << (i * 8);
                }
            }
            return result;
        }
        
        if (offset + sizeof(T) > data_mem.size()) {
            return 0;
        }
        
        T result = 0;
        std::memcpy(&result, &data_mem[offset], sizeof(T));
        return result;
    }
    
    template<typename T>
    void WriteMemory(u64 vaddr, T value) {
        // Map to data memory region
        size_t offset = 0;
        if (vaddr >= DATA_MEM_BASE && vaddr < DATA_MEM_BASE + DATA_MEM_SIZE) {
            offset = vaddr - DATA_MEM_BASE;
        } else if (vaddr >= STACK_BASE && vaddr < STACK_BASE + STACK_SIZE) {
            offset = DATA_MEM_SIZE + (vaddr - STACK_BASE);
        } else if (vaddr >= TLS_MEM_BASE && vaddr < TLS_MEM_BASE + TLS_MEM_SIZE) {
            // TLS memory region
            offset = vaddr - TLS_MEM_BASE;
            if (offset + sizeof(T) > tls_mem.size()) {
                return;
            }
            std::memcpy(&tls_mem[offset], &value, sizeof(T));
            WriteFastmemBytes(vaddr, &value, sizeof(T));
            return;
        } else {
            // Write to extra_mem for arbitrary addresses
            for (size_t i = 0; i < sizeof(T); i++) {
                extra_mem[vaddr + i] = static_cast<u8>((value >> (i * 8)) & 0xFF);
            }
            return;
        }
        
        if (offset + sizeof(T) > data_mem.size()) {
            return;
        }
        
        std::memcpy(&data_mem[offset], &value, sizeof(T));
        WriteFastmemBytes(vaddr, &value, sizeof(T));
    }
    
    template<typename T>
    bool WriteMemoryExclusive(u64 vaddr, T value, T expected) {
        // Simple exclusive write - check expected and write if matches
        T current = ReadMemory<T>(vaddr);
        bool match = (current == expected);
        if (!match) {
            // Debug: print mismatch
            fprintf(stderr, "ExclusiveWrite mismatch: vaddr=0x%lX, current=0x%lX, expected=0x%lX, value=0x%lX\n",
                    (unsigned long)vaddr, (unsigned long)current, (unsigned long)expected, (unsigned long)value);
        }
        if (match) {
            WriteMemory<T>(vaddr, value);
            return true;
        }
        return false;
    }
    
    // Helper: Read TLS memory
    u64 ReadTlsMemory(u64 offset) {
        if (offset + 8 > TLS_MEM_SIZE) return 0;
        u64 val = 0;
        std::memcpy(&val, &tls_mem[offset], sizeof(val));
        return val;
    }
    
    // Helper: Write TLS memory
    void WriteTlsMemory(u64 offset, u64 value) {
        if (offset + 8 > TLS_MEM_SIZE) return;
        std::memcpy(&tls_mem[offset], &value, sizeof(value));
    }
    
    // Helper: Get register index from name (X0-X30)
    int GetRegIndex(const std::string& name) {
        if (name.length() >= 2 && name[0] == 'X') {
            int idx = std::stoi(name.substr(1));
            if (idx >= 0 && idx <= 30) return idx;
        }
        return -1;
    }
    
    void CallSVC(std::uint32_t swi) override {
        // JIT code may have touched data/TLS through fastmem directly.
        // SVC handlers operate on the backing test buffers, so keep them coherent here.
        SyncFastmemToData();

        // SVC 0 = standard test end (handled by BRK normally)
        if (swi == 0) {
            brk_hit = true;
            if (jit) jit->HaltExecution();
            return;
        }
        
        // Check if we have a configured action for this SVC
        bool found_action = false;
        while (svc_action_index < svc_actions.size()) {
            const auto& action = svc_actions[svc_action_index++];
            if (action.svc_num == swi) {
                HandleSvcAction(action);
                SyncDataToFastmem();
                found_action = true;
                break;
            }
            // Skip actions that don't match current SVC
            // This allows tests to have multiple SVCs in sequence
        }
        if (found_action) {
            return;
        }
        
        // Default SVC handling based on SVC number
        // These are designed to test TLS/SVC interaction
        switch (swi) {
            case 0x10:  // Read TLS[offset] -> X0
                if (jit) {
                    u64 offset = jit->GetRegister(1);  // X1 = offset
                    u64 val = ReadTlsMemory(offset);
                    jit->SetRegister(0, val);  // X0 = TLS[offset]
                }
                break;
                
            case 0x11:  // Write X0 -> TLS[offset]
                if (jit) {
                    u64 offset = jit->GetRegister(1);  // X1 = offset
                    u64 val = jit->GetRegister(0);     // X0 = value
                    WriteTlsMemory(offset, val);
                }
                break;
                
            case 0x12:  // Read TPIDR_EL0 -> X0
                if (jit) {
                    jit->SetRegister(0, tpidr_el0);
                }
                break;
                
            case 0x13:  // Write X0 -> TPIDR_EL0
                if (jit) {
                    tpidr_el0 = jit->GetRegister(0);
                }
                break;
                
            case 0x14:  // Read TLS[offset] -> X0 (alternative)
            case 0x15:  // Read TLS[offset] -> X0 (alternative 2)
                if (jit) {
                    u64 offset = jit->GetRegister(1);  // X1 = offset
                    u64 val = ReadTlsMemory(offset);
                    jit->SetRegister(0, val);  // X0 = TLS[offset]
                }
                break;
                
            case 0x16:  // Write X0 -> TLS[offset] (alternative)
            case 0x17:  // Write X0 -> TLS[offset] (alternative 2)
                if (jit) {
                    u64 offset = jit->GetRegister(1);  // X1 = offset
                    u64 val = jit->GetRegister(0);     // X0 = value
                    WriteTlsMemory(offset, val);
                }
                break;
                
            case 0x20:  // Verify IPC layout (Switch-style)
                // This simulates how Switch kernel reads TLS after SVC
                // Expected: HipcHeader at offset 0, CmifOutHeader at offset 16
                if (jit) {
                    // Read HipcHeader
                    u32 hipc_low = static_cast<u32>(ReadTlsMemory(0));
                    u32 hipc_high = static_cast<u32>(ReadTlsMemory(4));
                    // Read CmifOutHeader at offset 16
                    u32 magic = static_cast<u32>(ReadTlsMemory(16));
                    
                    // Verify: SFCO magic = 0x4F434653
                    bool valid = (magic == 0x4F434653);
                    jit->SetRegister(0, valid ? 1 : 0);
                }
                break;
                
            case 0x21:  // Simulate Switch SVC: write response to TLS
                // This simulates kernel writing IPC response
                if (jit) {
                    // Write HipcHeader
                    WriteTlsMemory(0, 0ULL);  // HipcHeader low
                    WriteTlsMemory(4, 0x0EULL);  // HipcHeader high (num_data_words = 14)
                    // Write CmifOutHeader at offset 16 (16-byte aligned)
                    WriteTlsMemory(16, 0x4F434653ULL);  // SFCO magic
                    WriteTlsMemory(20, 0ULL);  // version
                    WriteTlsMemory(24, 0ULL);  // result
                    WriteTlsMemory(28, 0ULL);  // token
                }
                break;
                
            case 0x30:  // Memory sync barrier test
                // Ensure all writes are visible
                std::atomic_thread_fence(std::memory_order_seq_cst);
                break;
                
            case 0xFF:  // Force halt (for debugging)
                if (jit) jit->HaltExecution();
                break;
                
            default:
                // Unknown SVC - halt for debugging
                fmt::println(stderr, "Unknown SVC: 0x{:X} at PC=0x{:016X}", 
                            swi, jit ? jit->GetPC() : 0);
                std::fprintf(stderr, "Unhandled SVC: 0x{:X}\n", swi); std::abort();
        }

        SyncDataToFastmem();
    }
    
    void HandleSvcAction(const SvcAction& action) {
        if (!jit) return;
        
        if (action.action == "read_tls") {
            u64 val = ReadTlsMemory(action.offset);
            jit->SetRegister(0, val);  // Always set X0 for consistency with default handler
            if (!action.result_reg.empty()) {
                int idx = GetRegIndex(action.result_reg);
                if (idx >= 0 && idx != 0) {  // Don't overwrite X0 again
                    jit->SetRegister(idx, val);
                }
            }
        } 
        else if (action.action == "write_tls") {
            WriteTlsMemory(action.offset, action.value);
        }
        else if (action.action == "verify_layout") {
            // Verify IPC layout matches expected
            u32 magic = static_cast<u32>(ReadTlsMemory(action.offset));
            bool valid = (magic == static_cast<u32>(action.value));
            jit->SetRegister(0, valid ? 1 : 0);  // Always set X0
            if (!action.result_reg.empty()) {
                int idx = GetRegIndex(action.result_reg);
                if (idx >= 0 && idx != 0) {
                    jit->SetRegister(idx, valid ? 1 : 0);
                }
            }
        }
        else if (action.action == "halt") {
            jit->HaltExecution();
        }
    }
    
    void ExceptionRaised(u64 pc, Dynarmic::A64::Exception exception) override {
        if (exception == Dynarmic::A64::Exception::Breakpoint) {
            brk_hit = true;
            brk_pc = pc;
            // Halt execution so JIT doesn't continue to next block
            if (jit) {
                jit->HaltExecution();
            }
            return;  // Don't assert on BRK, it's our test end marker
        }
        // Handle hint instructions that raise exceptions
        // YIELD, WFE, WFI, SEV, SEVL are hint instructions that may raise exceptions
        // For testing purposes, we just ignore them and continue
        if (exception == Dynarmic::A64::Exception::Yield ||
            exception == Dynarmic::A64::Exception::WaitForEvent ||
            exception == Dynarmic::A64::Exception::WaitForInterrupt ||
            exception == Dynarmic::A64::Exception::SendEvent ||
            exception == Dynarmic::A64::Exception::SendEventLocal) {
            return;  // Just continue execution
        }
        unexpected_exception = true;
        unexpected_exception_message =
            fmt::format("ExceptionRaised({:016x}, {})", pc, static_cast<int>(exception));
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
    
    std::uint64_t GetCNTPCT() override {
        return 0x10000000000 - ticks_left;
    }
    
    void DataCacheOperationRaised(Dynarmic::A64::DataCacheOperation op, u64 value) override {
        // Handle DC ZVA - zero a cache line worth of memory
        // For testing, just make this a no-op
        (void)op;
        (void)value;
    }
    
    void InstructionCacheOperationRaised(Dynarmic::A64::InstructionCacheOperation op, u64 value) override {
        // IC operations are no-ops for testing
        (void)op;
        (void)value;
    }
    
    void InstructionSynchronizationBarrierRaised() override {
        // ISB is a no-op for testing
    }
};

// ============================================================================
// Assembly Compiler
// ============================================================================

bool CompileAsmToBinary(const std::string& asm_path, const std::string& bin_path) {
    // Create temp file paths
    std::string obj_path = asm_path + ".o";
    std::string elf_path = asm_path + ".elf";
    
    // Step 1: Compile assembly to object file
    std::string cmd = "aarch64-none-elf-as -march=armv8.9-a+crc+crypto+sha3+sm4 -o \"" + obj_path + "\" \"" + asm_path + "\" 2>&1";
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
    
    // Step 2: Link to resolve relocations (using -Ttext=0 to set base address)
    // The linker resolves symbols like :lo12:target that the assembler leaves as relocations
    cmd = "aarch64-none-elf-ld -Ttext=0 -o \"" + elf_path + "\" \"" + obj_path + "\" 2>&1";
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
        fmt::println(stderr, "Linking failed:\n{}", output);
        return false;
    }
    
    // Step 3: Extract binary from linked ELF
    cmd = "aarch64-none-elf-objcopy -O binary \"" + elf_path + "\" \"" + bin_path + "\" 2>&1";
    pipe = popen(cmd.c_str(), "r");
    if (!pipe) {
        unlink(elf_path.c_str());
        return false;
    }
    
    output.clear();
    while (fgets(buffer, sizeof(buffer), pipe)) {
        output += buffer;
    }
    result = pclose(pipe);
    
    unlink(elf_path.c_str());
    
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
    
    // Read as 32-bit words
    std::vector<u32> code(size / 4);
    file.read(reinterpret_cast<char*>(code.data()), size);
    
    return code;
}

// ============================================================================
// Test File Parser
// ============================================================================

// Trim leading and trailing whitespace
[[maybe_unused]] static std::string Trim(const std::string& s) {
    size_t start = s.find_first_not_of(" \t\r\n");
    if (start == std::string::npos) return "";
    size_t end = s.find_last_not_of(" \t\r\n");
    return s.substr(start, end - start + 1);
}

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
    AsmTestEnv env;
    env.code_mem = code;
    
    // Initialize memory from MemData
    for (const auto& [addr, values] : config.mem_data) {
        for (size_t i = 0; i < values.size(); i++) {
            // Write 64-bit value to memory
            env.WriteMemory64(addr + i * 8, values[i]);
        }
    }
    
    // Initialize TLS memory from TlsData
    for (const auto& [offset, values] : config.tls_data) {
        for (size_t i = 0; i < values.size(); i++) {
            u64 tls_offset = offset + i * 8;
            if (tls_offset + 8 <= TLS_MEM_SIZE) {
                std::memcpy(&env.tls_mem[tls_offset], &values[i], sizeof(u64));
            }
        }
    }
    
    // Set up SVC actions for testing
    env.svc_actions = config.svc_actions;
    env.svc_action_index = 0;
    
    // Create exclusive monitor for LDAXR/STLXR instructions
    Dynarmic::ExclusiveMonitor monitor{1};
    
    Dynarmic::A64::UserConfig jit_config;
    
    jit_config.callbacks = &env;
    jit_config.global_monitor = &monitor;
    jit_config.processor_id = 0;
    jit_config.hook_data_cache_operations = true;  // Use callback for DC operations
    
    // Configure TLS pointers
    if (config.has_tpidr_el0_init) {
        env.tpidr_el0 = config.tpidr_el0_init;
    }
    if (config.has_tpidrro_el0_init) {
        env.tpidrro_el0 = config.tpidrro_el0_init;
    }
    jit_config.tpidr_el0 = &env.tpidr_el0;
    jit_config.tpidrro_el0 = &env.tpidrro_el0;

    // Enable fastmem for AMCAS exclusive memory access
    if (env.fastmem_arena) {
        jit_config.fastmem_pointer = reinterpret_cast<std::uintptr_t>(env.fastmem_arena);
        jit_config.fastmem_address_space_bits = 16;  // 64KB arena
        // Sparse MemData entries outside the arena-backed window must fall back to callbacks.
        jit_config.silently_mirror_fastmem = false;
        jit_config.fastmem_exclusive_access = true;
    }
    
    Dynarmic::A64::Jit jit{jit_config};

        env.jit = &jit;  // Set pointer so ExceptionRaised can halt execution

        // Sync code and data to fastmem arena before running
        env.SyncCodeToFastmem();
        env.SyncDataToFastmem();

        jit.SetPC(0);
        jit.SetFpcr(config.init_fpcr);
        jit.SetFpsr(config.init_fpsr);
        jit.SetPstate(config.init_pstate);

        // Set SP to point to the middle of our stack region

        // This allows tests to use SP for memory operations

        jit.SetSP(STACK_BASE + STACK_SIZE / 2);

        // Initialize registers from init_regs (RegData)
        for (const auto& [name, value] : config.init_regs) {
            std::string name_upper = name;
            for (auto& c : name_upper) c = std::toupper(c);
            
            if (name_upper[0] == 'X') {
                size_t reg_index = std::stoul(name.substr(1));
                if (reg_index < 31) {
                    jit.SetRegister(reg_index, value);
                }
            } else if (name_upper[0] == 'W') {
                // W register is lower 32 bits of X register
                size_t reg_index = std::stoul(name.substr(1));
                if (reg_index < 31) {
                    // Set only lower 32 bits, preserve upper bits
                    uint64_t current = jit.GetRegister(reg_index);
                    uint64_t new_val = (current & 0xFFFFFFFF00000000ULL) | (value & 0xFFFFFFFF);
                    jit.SetRegister(reg_index, new_val);
                }
            } else if (name_upper == "SP") {
                jit.SetSP(value);
            } else if (name_upper[0] == 'S' || name_upper[0] == 'D') {
                // Vector registers - set low bits
                size_t reg_index = std::stoul(name.substr(1));
                Vector vec = jit.GetVector(reg_index);
                vec[0] = value;
                jit.SetVector(reg_index, vec);
            }
        }
        
        // Initialize vector registers from init_vecs (VecData)
        for (const auto& [name, value] : config.init_vecs) {
            std::string name_upper = name;
            for (auto& c : name_upper) c = std::toupper(c);
            
            if (name_upper[0] == 'V' || name_upper[0] == 'Q') {
                size_t reg_index = std::stoul(name.substr(1));
                Vector vec = {value.first, value.second};
                jit.SetVector(reg_index, vec);
            }
        }
    
    // Run until BRK or timeout
    env.ticks_left = config.max_ticks;
    try {
        jit.Run();
    } catch (const std::exception& e) {
        result.passed = false;
        result.error_msg = fmt::format("Unhandled exception: {}", e.what());
        return result;
    }

    // Sync fastmem arena back to data_mem for verification
    env.SyncFastmemToData();

    if (env.unexpected_exception) {
        result.passed = false;
        result.error_msg = env.unexpected_exception_message;
        return result;
    }

    if (!env.brk_hit) {
        result.passed = false;
        result.error_msg = "Test did not hit BRK instruction (timeout or error)";
        return result;
    }

    // Check expected values
    int errors = 0;

    if (config.has_expected_pstate) {
        const uint32_t actual = jit.GetPstate();
        if (actual != config.expected_pstate) {
            result.error_msg += fmt::format("PSTATE: expected 0x{:08X}, got 0x{:08X}\n",
                config.expected_pstate, actual);
            errors++;
        }
    }

    if (config.has_expected_fpcr) {
        const uint32_t actual = jit.GetFpcr();
        if (actual != config.expected_fpcr) {
            result.error_msg += fmt::format("FPCR: expected 0x{:08X}, got 0x{:08X}\n",
                config.expected_fpcr, actual);
            errors++;
        }
    }

    if (config.has_expected_fpsr) {
        const uint32_t actual = jit.GetFpsr();
        if (actual != config.expected_fpsr) {
            result.error_msg += fmt::format("FPSR: expected 0x{:08X}, got 0x{:08X}\n",
                config.expected_fpsr, actual);
            errors++;
        }
    }

    for (const auto& [addr, values] : config.expected_mem_data) {
        for (size_t i = 0; i < values.size(); i++) {
            const uint64_t actual = env.ReadMemory64(addr + i * 8);
            if (actual != values[i]) {
                result.error_msg += fmt::format("MEM[0x{:016X}]: expected 0x{:016X}, got 0x{:016X}\n",
                    addr + i * 8, values[i], actual);
                errors++;
            }
        }
    }

    // Check expected values
    
    // Check registers (X, S, D) - Q registers are handled in VecData
    for (const auto& [name, expected] : config.expected_regs) {
        std::string name_upper = name;
        for (auto& c : name_upper) c = std::toupper(c);
        
        // Parse register name (X0-X30, SP, S0-S31, D0-D31)
        if (name_upper == "SP") {
            uint64_t actual = jit.GetSP();
            if (actual != expected) {
                result.error_msg += fmt::format("{}: expected 0x{:016X}, got 0x{:016X}\n",
                    name, expected, actual);
                errors++;
            }
            continue;
        }

        size_t reg_index = 0;

        if (name_upper[0] == 'X') {
            // X register (64-bit GPR)
            reg_index = std::stoul(name.substr(1));
            uint64_t actual = jit.GetRegister(reg_index);
            if (actual != expected) {
                result.error_msg += fmt::format("{}: expected 0x{:016X}, got 0x{:016X}\n", 
                    name, expected, actual);
                errors++;
            }
        } else if (name_upper[0] == 'W') {
            // W register (lower 32 bits of X register)
            reg_index = std::stoul(name.substr(1));
            uint32_t actual = static_cast<uint32_t>(jit.GetRegister(reg_index) & 0xFFFFFFFF);
            uint32_t exp32 = static_cast<uint32_t>(expected & 0xFFFFFFFF);
            if (actual != exp32) {
                result.error_msg += fmt::format("{}: expected 0x{:08X}, got 0x{:08X}\n",
                    name, exp32, actual);
                errors++;
            }
        } else if (name_upper[0] == 'S') {
            // S register (32-bit float, low 32 bits of V register)
            reg_index = std::stoul(name.substr(1));
            Vector vec = jit.GetVector(reg_index);
            uint32_t actual = static_cast<uint32_t>(vec[0] & 0xFFFFFFFF);
            uint32_t exp32 = static_cast<uint32_t>(expected & 0xFFFFFFFF);
            if (actual != exp32) {
                result.error_msg += fmt::format("{}: expected 0x{:08X}, got 0x{:08X}\n", 
                    name, exp32, actual);
                errors++;
            }
        } else if (name_upper[0] == 'D') {
            // D register (64-bit float, low 64 bits of V register)
            reg_index = std::stoul(name.substr(1));
            Vector vec = jit.GetVector(reg_index);
            uint64_t actual = vec[0];
            if (actual != expected) {
                result.error_msg += fmt::format("{}: expected 0x{:016X}, got 0x{:016X}\n", 
                    name, expected, actual);
                errors++;
            }
        } else {
            continue;
        }
    }
    
    // Check vectors
    for (const auto& [name, expected] : config.expected_vecs) {
        // Parse vector name (V0-V31)
        size_t reg_index = std::stoul(name.substr(1));
        Vector actual = jit.GetVector(reg_index);
        
        if (actual[0] != expected.first || actual[1] != expected.second) {
            result.error_msg += fmt::format("{}: expected [0x{:016X}, 0x{:016X}], got [0x{:016X}, 0x{:016X}]\n", 
                name, expected.second, expected.first, actual[1], actual[0]);
            errors++;
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
        fmt::println(stderr, "  Run AArch64 assembly tests through dynarmic JIT");
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
    
    fmt::println("ASM Test Runner (dynarmic)");
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
