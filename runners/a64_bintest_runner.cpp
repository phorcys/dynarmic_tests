/*
 * dynarmic_bintest_runner - Binary Test Runner for dynarmic
 * 
 * Runs compiled C/C++ tests on dynarmic JIT emulator.
 * Tests use real Linux ARM64 syscalls for compatibility with QEMU.
 * 
 * ARM64 Linux syscall convention:
 * - syscall number in x8
 * - arguments in x0-x5
 * - return value in x0
 */

#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <map>
#include <optional>
#include <string>
#include <vector>
#include <unistd.h>
#include <sys/wait.h>

#include <fmt/format.h>

#include "dynarmic/interface/A64/a64.h"

namespace fs = std::filesystem;

using u8 = std::uint8_t;
using u64 = std::uint64_t;
using Vector = Dynarmic::A64::Vector;

// Linux ARM64 syscall numbers
constexpr uint64_t SYS_READ       = 63;
constexpr uint64_t SYS_WRITE      = 64;
constexpr uint64_t SYS_EXIT       = 93;
constexpr uint64_t SYS_EXIT_GROUP = 94;
constexpr uint64_t SYS_GETPID     = 172;

// Custom test syscalls (high numbers to avoid conflict with Linux)
constexpr uint64_t SYS_TEST_ASSERT = 0x1000;
constexpr uint64_t SYS_TEST_PASS   = 0x1001;
constexpr uint64_t SYS_TEST_FAIL   = 0x1002;

// Memory configuration
constexpr uint64_t CODE_BASE = 0x10000;       // Code starts at 64KB
constexpr uint64_t CODE_SIZE = 0x100000;      // 1MB code
constexpr uint64_t DATA_BASE = 0x100000;      // Data at 1MB
constexpr uint64_t DATA_SIZE = 0x100000;      // 1MB data
constexpr uint64_t STACK_BASE = 0x800000;     // Stack at 8MB
constexpr uint64_t STACK_SIZE = 0x100000;     // 1MB stack
constexpr uint64_t TLS_BASE = 0x900000;       // TLS at 9MB
constexpr uint64_t TLS_SIZE = 0x10000;        // 64KB TLS
constexpr uint64_t TOTAL_MEM = 0x1000000;     // 16MB total

// ELF structures
struct Elf64_Ehdr {
    uint8_t e_ident[16];
    uint16_t e_type;
    uint16_t e_machine;
    uint32_t e_version;
    uint64_t e_entry;
    uint64_t e_phoff;
    uint64_t e_shoff;
    uint32_t e_flags;
    uint16_t e_ehsize;
    uint16_t e_phentsize;
    uint16_t e_phnum;
    uint16_t e_shentsize;
    uint16_t e_shnum;
    uint16_t e_shstrndx;
};

struct Elf64_Phdr {
    uint32_t p_type;
    uint32_t p_flags;
    uint64_t p_offset;
    uint64_t p_vaddr;
    uint64_t p_paddr;
    uint64_t p_filesz;
    uint64_t p_memsz;
    uint64_t p_align;
};

// Test result
struct TestResult {
    std::string name;
    bool passed = false;
    int exit_code = -1;
    int assert_line = -1;
    std::string output;
    uint64_t ticks = 0;
};

// Test environment
class TestEnv : public Dynarmic::A64::UserCallbacks {
public:
    u64 ticks_left = 0;
    std::vector<u8> memory;
    uint64_t entry_point = 0;
    Dynarmic::A64::Jit* jit = nullptr;  // Pointer to JIT
    
    // TLS storage (for TPIDR_EL0 and TPIDRRO_EL0)
    u64 tpidr_el0 = 0;
    u64 tpidrro_el0 = 0;
    
    // Result tracking
    TestResult* result = nullptr;
    bool test_complete = false;
    
    TestEnv() : memory(TOTAL_MEM, 0) {}
    
    bool IsValidAddress(uint64_t vaddr) const {
        return vaddr < TOTAL_MEM;
    }
    
    // Code read
    std::optional<std::uint32_t> MemoryReadCode(u64 vaddr) override {
        if (!IsValidAddress(vaddr + 3)) {
            return 0x14000000;  // B .
        }
        uint32_t instr;
        std::memcpy(&instr, &memory[vaddr], sizeof(instr));
        return instr;
    }
    
    // Memory reads
    std::uint8_t MemoryRead8(u64 vaddr) override {
        if (!IsValidAddress(vaddr)) return 0;
        return memory[vaddr];
    }
    
    std::uint16_t MemoryRead16(u64 vaddr) override {
        if (!IsValidAddress(vaddr + 1)) return 0;
        uint16_t val;
        std::memcpy(&val, &memory[vaddr], sizeof(val));
        return val;
    }
    
    std::uint32_t MemoryRead32(u64 vaddr) override {
        if (!IsValidAddress(vaddr + 3)) return 0;
        uint32_t val;
        std::memcpy(&val, &memory[vaddr], sizeof(val));
        return val;
    }
    
    std::uint64_t MemoryRead64(u64 vaddr) override {
        if (!IsValidAddress(vaddr + 7)) return 0;
        uint64_t val;
        std::memcpy(&val, &memory[vaddr], sizeof(val));
        return val;
    }
    
    Vector MemoryRead128(u64 vaddr) override {
        Vector result{};
        if (!IsValidAddress(vaddr + 15)) return result;
        std::memcpy(&result[0], &memory[vaddr], sizeof(u64));
        std::memcpy(&result[1], &memory[vaddr + 8], sizeof(u64));
        return result;
    }
    
    // Memory writes
    void MemoryWrite8(u64 vaddr, std::uint8_t value) override {
        if (IsValidAddress(vaddr)) {
            memory[vaddr] = value;
        }
    }
    
    void MemoryWrite16(u64 vaddr, std::uint16_t value) override {
        if (IsValidAddress(vaddr + 1)) {
            std::memcpy(&memory[vaddr], &value, sizeof(value));
        }
    }
    
    void MemoryWrite32(u64 vaddr, std::uint32_t value) override {
        if (IsValidAddress(vaddr + 3)) {
            std::memcpy(&memory[vaddr], &value, sizeof(value));
        }
    }
    
    void MemoryWrite64(u64 vaddr, std::uint64_t value) override {
        if (IsValidAddress(vaddr + 7)) {
            std::memcpy(&memory[vaddr], &value, sizeof(value));
        }
    }
    
    void MemoryWrite128(u64 vaddr, Vector value) override {
        if (IsValidAddress(vaddr + 15)) {
            std::memcpy(&memory[vaddr], &value[0], sizeof(u64));
            std::memcpy(&memory[vaddr + 8], &value[1], sizeof(u64));
        }
    }
    
    // Exclusive writes (not used in tests)
    bool MemoryWriteExclusive8(u64, std::uint8_t, std::uint8_t) override { return false; }
    bool MemoryWriteExclusive16(u64, std::uint16_t, std::uint16_t) override { return false; }
    bool MemoryWriteExclusive32(u64, std::uint32_t, std::uint32_t) override { return false; }
    bool MemoryWriteExclusive64(u64, std::uint64_t, std::uint64_t) override { return false; }
    bool MemoryWriteExclusive128(u64, Vector, Vector) override { return false; }
    
    // SVC handler - Linux ARM64 syscalls only
    void CallSVC(std::uint32_t swi) override {
        if (!jit) {
            return;
        }
        
        // Linux ARM64: syscall number in x8, swi is typically 0
        uint64_t syscall_num = jit->GetRegister(8);
        uint64_t x0 = jit->GetRegister(0);
        uint64_t x1 = jit->GetRegister(1);
        uint64_t x2 = jit->GetRegister(2);
        
        // Handle Linux ARM64 syscalls
        switch (syscall_num) {
            case SYS_WRITE: {
                // write(fd, buf, count)
                int fd = (int)x0;
                uint64_t buf_addr = x1;
                uint64_t count = x2;
                
                if (IsValidAddress(buf_addr) && count > 0) {
                    // Read string from emulated memory
                    std::string str;
                    for (uint64_t i = 0; i < count && IsValidAddress(buf_addr + i); i++) {
                        str += static_cast<char>(memory[buf_addr + i]);
                    }
                    
                    // Output to host
                    if (fd == 1) {  // stdout
                        result->output += str;
                        fwrite(str.data(), 1, str.size(), stdout);
                        fflush(stdout);
                    } else if (fd == 2) {  // stderr
                        fwrite(str.data(), 1, str.size(), stderr);
                        fflush(stderr);
                    }
                    
                    // Return bytes written
                    jit->SetRegister(0, count);
                } else {
                    jit->SetRegister(0, static_cast<uint64_t>(-1));  // -1 error
                }
                break;
            }
            
            case SYS_READ: {
                // read(fd, buf, count) - not implemented, return 0
                jit->SetRegister(0, 0);
                break;
            }
            
            case SYS_EXIT:
            case SYS_EXIT_GROUP: {
                // exit(status)
                int status = (int)x0;
                result->exit_code = status;
                result->passed = (status == 0);
                test_complete = true;
                jit->HaltExecution();
                break;
            }
            
            case SYS_GETPID: {
                // getpid() - return fake PID
                jit->SetRegister(0, 1);
                break;
            }
            
            case SYS_TEST_ASSERT: {
                // assert(cond, line) - custom syscall
                int cond = (int)x0;
                int line = (int)x1;
                if (!cond) {
                    char buf[64];
                    snprintf(buf, sizeof(buf), "ASSERTION FAILED at line %d\n", line);
                    result->output += buf;
                    fprintf(stderr, "%s", buf);
                    result->assert_line = line;
                    result->passed = false;
                    test_complete = true;
                    jit->HaltExecution();
                }
                break;
            }
            
            case SYS_TEST_PASS: {
                // test_pass() - custom syscall
                result->passed = true;
                result->output += "[PASS]\n";
                printf("[PASS]\n");
                test_complete = true;
                jit->HaltExecution();
                break;
            }
            
            case SYS_TEST_FAIL: {
                // test_fail(line) - custom syscall
                int line = (int)x0;
                result->passed = false;
                result->assert_line = line;
                char buf[64];
                snprintf(buf, sizeof(buf), "[FAIL] at line %d\n", line);
                result->output += buf;
                printf("%s", buf);
                test_complete = true;
                jit->HaltExecution();
                break;
            }
            
            default:
                fmt::print(stderr, "Unknown syscall: 0x{:X}\n", syscall_num);
                // Return error
                jit->SetRegister(0, static_cast<uint64_t>(-38));  // -ENOSYS
                break;
        }
    }
    
    void ExceptionRaised(u64 pc, Dynarmic::A64::Exception exception) override {
        if (exception == Dynarmic::A64::Exception::Breakpoint) {
            // BRK instruction - test end marker
            test_complete = true;
            return;
        }
        fmt::print(stderr, "Exception {} at PC {:X}\n", static_cast<size_t>(exception), pc);
        test_complete = true;
    }
    
    void AddTicks(u64 ticks) override {
        ticks_left = (ticks > ticks_left) ? 0 : (ticks_left - ticks);
    }
    
    u64 GetTicksRemaining() override {
        return ticks_left;
    }
    
    u64 GetCNTPCT() override {
        return 0x10000000000 - ticks_left;
    }
    
    // Read string from memory
    std::string ReadString(uint64_t vaddr, uint64_t max_len = 1024) const {
        std::string result;
        while (IsValidAddress(vaddr) && result.size() < max_len) {
            char c = memory[vaddr++];
            if (c == '\0') break;
            result += c;
        }
        return result;
    }
};

// Load ELF file into memory
bool LoadElf(const std::string& filename, TestEnv& env) {
    std::ifstream file(filename, std::ios::binary);
    if (!file) {
        std::cerr << "Cannot open file: " << filename << std::endl;
        return false;
    }
    
    Elf64_Ehdr ehdr;
    file.read(reinterpret_cast<char*>(&ehdr), sizeof(ehdr));
    
    // Verify ELF magic
    if (ehdr.e_ident[0] != 0x7F || ehdr.e_ident[1] != 'E' ||
        ehdr.e_ident[2] != 'L' || ehdr.e_ident[3] != 'F') {
        std::cerr << "Not an ELF file: " << filename << std::endl;
        return false;
    }
    
    // Check for ARM64
    if (ehdr.e_machine != 183) {  // EM_AARCH64
        std::cerr << "Not an ARM64 ELF: " << filename << std::endl;
        return false;
    }
    
    env.entry_point = ehdr.e_entry;
    
    // Load program headers
    for (int i = 0; i < ehdr.e_phnum; i++) {
        file.seekg(ehdr.e_phoff + i * ehdr.e_phentsize);
        Elf64_Phdr phdr;
        file.read(reinterpret_cast<char*>(&phdr), sizeof(phdr));
        
        if (phdr.p_type == 1) {  // PT_LOAD
            uint64_t vaddr = phdr.p_vaddr;
            uint64_t memsz = phdr.p_memsz;
            
            if (vaddr + memsz <= TOTAL_MEM) {
                // Zero the region
                std::fill_n(&env.memory[vaddr], memsz, 0);
                
                // Read file contents
                if (phdr.p_filesz > 0) {
                    file.seekg(phdr.p_offset);
                    file.read(reinterpret_cast<char*>(&env.memory[vaddr]), phdr.p_filesz);
                    fmt::print(stderr, "Loaded segment: vaddr=0x{:X}, offset=0x{:X}, filesz=0x{:X}, memsz=0x{:X}\n", 
                              vaddr, phdr.p_offset, phdr.p_filesz, memsz);
                }
            } else {
                fmt::print(stderr, "Segment too large: vaddr=0x{:X}, memsz=0x{:X}, TOTAL_MEM=0x{:X}\n",
                          vaddr, memsz, TOTAL_MEM);
            }
        }
    }
    
    fmt::print(stderr, "Entry point: 0x{:X}\n", env.entry_point);
    fmt::print(stderr, "First bytes at entry: {:02X} {:02X} {:02X} {:02X}\n", 
              env.memory[env.entry_point], env.memory[env.entry_point+1],
              env.memory[env.entry_point+2], env.memory[env.entry_point+3]);
    
    return true;
}

// Run a single test
TestResult RunTest(const std::string& test_file) {
    TestResult result;
    result.name = fs::path(test_file).stem().string();
    
    TestEnv env;
    env.result = &result;
    
    // Load ELF
    if (!LoadElf(test_file, env)) {
        result.passed = false;
        result.output = "Failed to load ELF file\n";
        return result;
    }
    
    // Set up stack
    uint64_t sp = STACK_BASE + STACK_SIZE - 16;
    env.MemoryWrite64(sp, 0);  // Return address (0 = exit)
    
    // Create JIT
    Dynarmic::A64::UserConfig config;
    config.callbacks = &env;
    
    // Set up TLS pointers (for TPIDR_EL0 and TPIDRRO_EL0)
    // TPIDRRO_EL0 is read-only, point to TLS area
    env.tpidrro_el0 = TLS_BASE;
    // TPIDR_EL0 is read-write, point to TLS area + offset
    env.tpidr_el0 = TLS_BASE + 0x1000;
    
    config.tpidrro_el0 = &env.tpidrro_el0;
    config.tpidr_el0 = &env.tpidr_el0;
    
    auto jit = std::make_unique<Dynarmic::A64::Jit>(config);
    env.jit = jit.get();  // Set JIT pointer for callbacks
    
    // Set initial state
    jit->SetPC(env.entry_point);
    jit->SetSP(sp);
    
    // Set initial NZCV with Z=1 (0x40000000) to match QEMU default
    jit->SetPstate(0x40000000);
    
    // Clear registers
    for (int i = 0; i < 31; i++) {
        jit->SetRegister(i, 0);
    }
    for (int i = 0; i < 32; i++) {
        jit->SetVector(i, Vector{});
    }
    
    // Set tick limit (prevent infinite loops)
    // SIMDe tests need more cycles due to extensive testing
    env.ticks_left = 10000000000ULL;  // 10 billion cycles
    
    // Run test
    uint64_t last_ticks = env.ticks_left;
    int iterations = 0;
    
    try {
        while (!env.test_complete && env.ticks_left > 0) {
            jit->Run();
            iterations++;
            
            // Detect if no progress (stuck in infinite loop)
            if (env.ticks_left == last_ticks && iterations > 10) {
                break;
            }
            last_ticks = env.ticks_left;
        }
        
        if (env.ticks_left == 0) {
            result.output += "Test timeout (exceeded tick limit)\n";
            result.passed = false;
        }
    } catch (const std::exception& e) {
        result.output += std::string("Exception: ") + e.what() + "\n";
        result.passed = false;
    }
    
    return result;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cout << "dynarmic_bintest_runner - Binary Test Runner\n\n";
        std::cout << "Usage: " << argv[0] << " <test.elf|test_directory>\n";
        std::cout << "\n";
        std::cout << "Runs compiled C/C++ tests on dynarmic JIT emulator.\n";
        std::cout << "Tests use Linux ARM64 syscalls for QEMU compatibility.\n";
        return 1;
    }
    
    std::vector<std::string> test_files;
    std::string input_path = argv[1];
    
    if (fs::is_directory(input_path)) {
        // Recursive directory scan
        for (const auto& entry : fs::recursive_directory_iterator(input_path)) {
            if (entry.path().extension() == ".elf") {
                test_files.push_back(entry.path().string());
            }
        }
        std::sort(test_files.begin(), test_files.end());
    } else {
        test_files.push_back(input_path);
    }
    
    if (test_files.empty()) {
        std::cerr << "No test files found\n";
        return 1;
    }
    
    std::cout << "dynarmic_bintest_runner\n";
    std::cout << "Found " << test_files.size() << " test file(s)\n\n";
    
    int passed = 0, failed = 0;
    
    for (const auto& test_file : test_files) {
        std::cout << "Testing: " << fs::path(test_file).stem().string() << " ... " << std::flush;
        
        TestResult result = RunTest(test_file);
        
        if (result.passed) {
            std::cout << "\033[32mPASSED\033[0m" << std::endl;
            passed++;
        } else {
            std::cout << "\033[31mFAILED\033[0m" << std::endl;
            failed++;
            if (!result.output.empty() && result.output != "[PASS]\n") {
                std::istringstream iss(result.output);
                std::string line;
                while (std::getline(iss, line)) {
                    std::cout << "  " << line << std::endl;
                }
            }
            if (result.assert_line >= 0) {
                std::cout << "  Assertion failed at line " << result.assert_line << std::endl;
            }
            if (result.exit_code > 0) {
                std::cout << "  Exit code: " << result.exit_code << std::endl;
            }
        }
    }
    
    std::cout << "\n" << std::string(50, '=') << "\n";
    std::cout << "Summary: " << passed << " passed, " << failed << " failed\n";
    
    return failed > 0 ? 1 : 0;
}
