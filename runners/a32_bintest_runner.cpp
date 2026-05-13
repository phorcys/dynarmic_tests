/*
 * dynarmic_bintest_runner_a32 - Binary Test Runner for dynarmic A32
 *
 * Runs compiled ARM32 ELF tests on dynarmic JIT emulator.
 * Tests use Linux ARM EABI syscalls for compatibility with qemu-arm.
 */

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <optional>
#include <sstream>
#include <string>
#include <vector>

#include <fmt/format.h>

#include "dynarmic/interface/A32/a32.h"
#include "dynarmic/interface/exclusive_monitor.h"

namespace fs = std::filesystem;

using u8 = std::uint8_t;
using u16 = std::uint16_t;
using u32 = std::uint32_t;
using u64 = std::uint64_t;

constexpr u32 SYS_READ       = 3;
constexpr u32 SYS_WRITE      = 4;
constexpr u32 SYS_EXIT       = 1;
constexpr u32 SYS_EXIT_GROUP = 248;
constexpr u32 SYS_GETPID     = 20;

constexpr u32 SYS_TEST_ASSERT = 0x1000;
constexpr u32 SYS_TEST_PASS   = 0x1001;
constexpr u32 SYS_TEST_FAIL   = 0x1002;

constexpr u32 STACK_BASE = 0x800000;
constexpr u32 STACK_SIZE = 0x100000;
constexpr u32 TOTAL_MEM  = 0x1000000;

struct Elf32_Ehdr {
    u8 e_ident[16];
    u16 e_type;
    u16 e_machine;
    u32 e_version;
    u32 e_entry;
    u32 e_phoff;
    u32 e_shoff;
    u32 e_flags;
    u16 e_ehsize;
    u16 e_phentsize;
    u16 e_phnum;
    u16 e_shentsize;
    u16 e_shnum;
    u16 e_shstrndx;
};

struct Elf32_Phdr {
    u32 p_type;
    u32 p_offset;
    u32 p_vaddr;
    u32 p_paddr;
    u32 p_filesz;
    u32 p_memsz;
    u32 p_flags;
    u32 p_align;
};

struct TestResult {
    std::string name;
    bool passed = false;
    int exit_code = -1;
    int assert_line = -1;
    std::string output;
};

class TestEnv final : public Dynarmic::A32::UserCallbacks {
public:
    u64 ticks_left = 0;
    std::vector<u8> memory = std::vector<u8>(TOTAL_MEM, 0);
    u32 entry_point = 0;
    Dynarmic::A32::Jit* jit = nullptr;

    TestResult* result = nullptr;
    bool test_complete = false;

    bool IsValidAddress(u32 vaddr, u32 size = 1) const {
        return size <= TOTAL_MEM && vaddr <= TOTAL_MEM - size;
    }

    std::optional<u32> MemoryReadCode(u32 vaddr) override {
        if (!IsValidAddress(vaddr, sizeof(u32))) {
            return 0xEAFFFFFE;  // B .
        }
        u32 instr;
        std::memcpy(&instr, &memory[vaddr], sizeof(instr));
        return instr;
    }

    u8 MemoryRead8(u32 vaddr) override {
        return IsValidAddress(vaddr) ? memory[vaddr] : 0;
    }
    u16 MemoryRead16(u32 vaddr) override {
        if (!IsValidAddress(vaddr, sizeof(u16))) return 0;
        u16 val;
        std::memcpy(&val, &memory[vaddr], sizeof(val));
        return val;
    }
    u32 MemoryRead32(u32 vaddr) override {
        if (!IsValidAddress(vaddr, sizeof(u32))) return 0;
        u32 val;
        std::memcpy(&val, &memory[vaddr], sizeof(val));
        return val;
    }
    u64 MemoryRead64(u32 vaddr) override {
        if (!IsValidAddress(vaddr, sizeof(u64))) return 0;
        u64 val;
        std::memcpy(&val, &memory[vaddr], sizeof(val));
        return val;
    }

    void MemoryWrite8(u32 vaddr, u8 value) override {
        if (IsValidAddress(vaddr)) memory[vaddr] = value;
    }
    void MemoryWrite16(u32 vaddr, u16 value) override {
        if (IsValidAddress(vaddr, sizeof(u16))) std::memcpy(&memory[vaddr], &value, sizeof(value));
    }
    void MemoryWrite32(u32 vaddr, u32 value) override {
        if (IsValidAddress(vaddr, sizeof(u32))) std::memcpy(&memory[vaddr], &value, sizeof(value));
    }
    void MemoryWrite64(u32 vaddr, u64 value) override {
        if (IsValidAddress(vaddr, sizeof(u64))) std::memcpy(&memory[vaddr], &value, sizeof(value));
    }

    bool MemoryWriteExclusive8(u32 vaddr, u8 value, u8 expected) override {
        if (!IsValidAddress(vaddr, sizeof(u8))) return false;
        const u8 current = MemoryRead8(vaddr);
        if (current != expected) return false;
        MemoryWrite8(vaddr, value);
        return true;
    }
    bool MemoryWriteExclusive16(u32 vaddr, u16 value, u16 expected) override {
        if (!IsValidAddress(vaddr, sizeof(u16))) return false;
        const u16 current = MemoryRead16(vaddr);
        if (current != expected) return false;
        MemoryWrite16(vaddr, value);
        return true;
    }
    bool MemoryWriteExclusive32(u32 vaddr, u32 value, u32 expected) override {
        if (!IsValidAddress(vaddr, sizeof(u32))) return false;
        const u32 current = MemoryRead32(vaddr);
        if (current != expected) return false;
        MemoryWrite32(vaddr, value);
        return true;
    }
    bool MemoryWriteExclusive64(u32 vaddr, u64 value, u64 expected) override {
        if (!IsValidAddress(vaddr, sizeof(u64))) return false;
        const u64 current = MemoryRead64(vaddr);
        if (current != expected) return false;
        MemoryWrite64(vaddr, value);
        return true;
    }

    void CallSVC(u32 swi) override {
        (void)swi;
        if (!jit) return;

        auto& regs = jit->Regs();
        const u32 syscall_num = regs[7];
        const u32 r0 = regs[0];
        const u32 r1 = regs[1];
        const u32 r2 = regs[2];

        switch (syscall_num) {
        case SYS_WRITE: {
            const int fd = static_cast<int>(r0);
            if (IsValidAddress(r1) && r2 > 0) {
                std::string str;
                str.reserve(r2);
                for (u32 i = 0; i < r2 && IsValidAddress(r1 + i); ++i) {
                    str.push_back(static_cast<char>(memory[r1 + i]));
                }
                if (fd == 1) {
                    result->output += str;
                    fwrite(str.data(), 1, str.size(), stdout);
                    fflush(stdout);
                } else if (fd == 2) {
                    fwrite(str.data(), 1, str.size(), stderr);
                    fflush(stderr);
                }
                regs[0] = r2;
            } else {
                regs[0] = static_cast<u32>(-1);
            }
            break;
        }
        case SYS_READ:
            regs[0] = 0;
            break;
        case SYS_EXIT:
        case SYS_EXIT_GROUP:
            result->exit_code = static_cast<int>(r0);
            result->passed = (r0 == 0);
            test_complete = true;
            jit->HaltExecution();
            break;
        case SYS_GETPID:
            regs[0] = 1;
            break;
        case SYS_TEST_ASSERT:
            if (static_cast<int>(r0) == 0) {
                const int line = static_cast<int>(r1);
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
        case SYS_TEST_PASS:
            result->passed = true;
            result->output += "[PASS]\n";
            printf("[PASS]\n");
            test_complete = true;
            jit->HaltExecution();
            break;
        case SYS_TEST_FAIL: {
            const int line = static_cast<int>(r0);
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
            fmt::print(stderr, "Unknown A32 syscall: 0x{:X}\n", syscall_num);
            regs[0] = static_cast<u32>(-38);
            break;
        }
    }

    void ExceptionRaised(u32 pc, Dynarmic::A32::Exception exception) override {
        if (exception == Dynarmic::A32::Exception::Breakpoint) {
            test_complete = true;
            return;
        }
        fmt::print(stderr, "A32 exception {} at PC {:08X}\n", static_cast<size_t>(exception), pc);
        test_complete = true;
    }

    void AddTicks(u64 ticks) override {
        ticks_left = ticks > ticks_left ? 0 : ticks_left - ticks;
    }
    u64 GetTicksRemaining() override {
        return ticks_left;
    }
};

static bool LoadElf(const std::string& filename, TestEnv& env) {
    std::ifstream file(filename, std::ios::binary);
    if (!file) {
        std::cerr << "Cannot open file: " << filename << '\n';
        return false;
    }

    Elf32_Ehdr ehdr{};
    file.read(reinterpret_cast<char*>(&ehdr), sizeof(ehdr));
    if (!file) {
        std::cerr << "Failed to read ELF header: " << filename << '\n';
        return false;
    }

    if (ehdr.e_ident[0] != 0x7F || ehdr.e_ident[1] != 'E' ||
        ehdr.e_ident[2] != 'L' || ehdr.e_ident[3] != 'F') {
        std::cerr << "Not an ELF file: " << filename << '\n';
        return false;
    }
    if (ehdr.e_machine != 40) {  // EM_ARM
        std::cerr << "Not an ARM ELF: " << filename << '\n';
        return false;
    }

    env.entry_point = ehdr.e_entry;
    for (int i = 0; i < ehdr.e_phnum; ++i) {
        file.seekg(static_cast<std::streamoff>(ehdr.e_phoff) + i * ehdr.e_phentsize);
        Elf32_Phdr phdr{};
        file.read(reinterpret_cast<char*>(&phdr), sizeof(phdr));
        if (phdr.p_type != 1) continue;

        if (!env.IsValidAddress(phdr.p_vaddr, phdr.p_memsz)) {
            fmt::print(stderr, "Segment too large: vaddr=0x{:X}, memsz=0x{:X}\n", phdr.p_vaddr, phdr.p_memsz);
            return false;
        }

        std::fill_n(&env.memory[phdr.p_vaddr], phdr.p_memsz, 0);
        if (phdr.p_filesz > 0) {
            file.seekg(phdr.p_offset);
            file.read(reinterpret_cast<char*>(&env.memory[phdr.p_vaddr]), phdr.p_filesz);
        }
    }
    return true;
}

static TestResult RunTest(const std::string& test_file) {
    TestResult result;
    result.name = fs::path(test_file).stem().string();

    TestEnv env;
    env.result = &result;

    if (!LoadElf(test_file, env)) {
        result.passed = false;
        result.output = "Failed to load ELF file\n";
        return result;
    }

    Dynarmic::ExclusiveMonitor monitor{1};
    Dynarmic::A32::UserConfig config;
    config.callbacks = &env;
    config.global_monitor = &monitor;
    config.processor_id = 0;
    Dynarmic::A32::Jit jit{config};
    env.jit = &jit;

    auto& regs = jit.Regs();
    regs.fill(0);
    jit.ExtRegs().fill(0);
    regs[13] = STACK_BASE + STACK_SIZE - 8;
    regs[14] = 0;
    regs[15] = env.entry_point;
    jit.SetCpsr(0x40000010);  // Z=1, ARM state, user mode

    env.ticks_left = 10000000000ULL;
    u64 last_ticks = env.ticks_left;
    int iterations = 0;

    try {
        while (!env.test_complete && env.ticks_left > 0) {
            jit.Run();
            ++iterations;
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
    std::string input_path = "bintest/out/a32";
    if (argc >= 2) {
        input_path = argv[1];
    }

    std::vector<std::string> test_files;
    if (fs::is_directory(input_path)) {
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
        std::cerr << "No A32 test files found\n";
        return 1;
    }

    std::cout << "dynarmic_bintest_runner_a32\n";
    std::cout << "Found " << test_files.size() << " test file(s)\n\n";

    int passed = 0;
    int failed = 0;

    for (const auto& test_file : test_files) {
        std::cout << "Testing: " << fs::path(test_file).stem().string() << " ... " << std::flush;
        TestResult result = RunTest(test_file);
        if (result.passed) {
            std::cout << "\033[32mPASSED\033[0m\n";
            ++passed;
        } else {
            std::cout << "\033[31mFAILED\033[0m\n";
            ++failed;
            if (!result.output.empty() && result.output != "[PASS]\n") {
                std::istringstream iss(result.output);
                std::string line;
                while (std::getline(iss, line)) {
                    std::cout << "  " << line << '\n';
                }
            }
            if (result.assert_line >= 0) {
                std::cout << "  Assertion failed at line " << result.assert_line << '\n';
            }
            if (result.exit_code > 0) {
                std::cout << "  Exit code: " << result.exit_code << '\n';
            }
        }
    }

    std::cout << "\n" << std::string(50, '=') << "\n";
    std::cout << "Summary: " << passed << " passed, " << failed << " failed\n";
    return failed > 0 ? 1 : 0;
}
