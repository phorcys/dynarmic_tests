/* This file is part of the dynarmic_tests project.
 * SPDX-License-Identifier: 0BSD
 */

#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <optional>
#include <vector>

#include <sys/mman.h>
#include <unistd.h>

#include "dynarmic/interface/A64/a64.h"

namespace {

using u8 = std::uint8_t;
using u16 = std::uint16_t;
using u32 = std::uint32_t;
using u64 = std::uint64_t;

constexpr size_t address_space_bits = 18;
constexpr size_t memory_size = 1ULL << address_space_bits;
constexpr u64 source_addr = 0x120;
constexpr u64 dest_addr = 0x1a0;
constexpr u64 fault_read_addr = 0x10000 + source_addr;
constexpr u64 fault_write_addr = 0x14000 + dest_addr;
constexpr u64 test_value = 0x8899aabbccddeeff;

[[noreturn]] void Fail(const char* message) {
    std::fprintf(stderr, "FAILED: %s\n", message);
    std::exit(1);
}

void Check(bool condition, const char* message) {
    if (!condition) {
        Fail(message);
    }
}

class MmapFastmemArena {
public:
    explicit MmapFastmemArena(size_t size_) : size{size_} {
        page_size = static_cast<size_t>(sysconf(_SC_PAGESIZE));
        ptr = static_cast<u8*>(mmap(nullptr, size, PROT_READ | PROT_WRITE,
                                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0));
        Check(ptr != MAP_FAILED, "mmap fastmem arena");
    }

    ~MmapFastmemArena() {
        if (ptr != MAP_FAILED) {
            munmap(ptr, size);
        }
    }

    MmapFastmemArena(const MmapFastmemArena&) = delete;
    MmapFastmemArena& operator=(const MmapFastmemArena&) = delete;

    u8* data() { return ptr; }

    const u8* data() const { return ptr; }

    void ProtectNoAccess(u64 vaddr) {
        Check((vaddr & (page_size - 1)) + sizeof(u64) <= page_size,
              "fault address crosses host page");
        Check(mprotect(ptr + (vaddr & ~(page_size - 1)), page_size, PROT_NONE) == 0,
              "mprotect none");
    }

    void ProtectReadWrite(u64 vaddr) {
        Check(mprotect(ptr + (vaddr & ~(page_size - 1)), page_size,
                       PROT_READ | PROT_WRITE)
                  == 0,
              "mprotect read/write");
    }

private:
    size_t size;
    size_t page_size{};
    u8* ptr{};
};

struct Env final : Dynarmic::A64::UserCallbacks {
    u64 ticks_left = 0;
    std::vector<u32> code_mem;
    std::vector<u8> callback_memory;
    size_t read_callbacks = 0;
    size_t write_callbacks = 0;

    Env() : callback_memory(memory_size) {}

    std::optional<u32> MemoryReadCode(u64 vaddr) override {
        if (vaddr >= code_mem.size() * sizeof(u32)) {
            return 0x14000000;  // B .
        }
        return code_mem[vaddr / sizeof(u32)];
    }

    template<typename T>
    T Read(u64 vaddr) const {
        T value;
        std::memcpy(&value, callback_memory.data() + vaddr, sizeof(T));
        return value;
    }

    template<typename T>
    void Write(u64 vaddr, T value) {
        std::memcpy(callback_memory.data() + vaddr, &value, sizeof(T));
    }

    std::uint8_t MemoryRead8(u64 vaddr) override {
        read_callbacks++;
        return Read<u8>(vaddr);
    }

    std::uint16_t MemoryRead16(u64 vaddr) override {
        read_callbacks++;
        return Read<u16>(vaddr);
    }

    std::uint32_t MemoryRead32(u64 vaddr) override {
        read_callbacks++;
        return Read<u32>(vaddr);
    }

    std::uint64_t MemoryRead64(u64 vaddr) override {
        read_callbacks++;
        return Read<u64>(vaddr);
    }

    Dynarmic::A64::Vector MemoryRead128(u64 vaddr) override {
        read_callbacks++;
        return Read<Dynarmic::A64::Vector>(vaddr);
    }

    void MemoryWrite8(u64 vaddr, std::uint8_t value) override {
        write_callbacks++;
        Write(vaddr, value);
    }

    void MemoryWrite16(u64 vaddr, std::uint16_t value) override {
        write_callbacks++;
        Write(vaddr, value);
    }

    void MemoryWrite32(u64 vaddr, std::uint32_t value) override {
        write_callbacks++;
        Write(vaddr, value);
    }

    void MemoryWrite64(u64 vaddr, std::uint64_t value) override {
        write_callbacks++;
        Write(vaddr, value);
    }

    void MemoryWrite128(u64 vaddr, Dynarmic::A64::Vector value) override {
        write_callbacks++;
        Write(vaddr, value);
    }

    void CallSVC(std::uint32_t) override { Fail("unexpected SVC"); }

    void ExceptionRaised(u64, Dynarmic::A64::Exception) override {
        Fail("unexpected guest exception");
    }

    void AddTicks(std::uint64_t ticks) override {
        ticks_left = ticks > ticks_left ? 0 : ticks_left - ticks;
    }

    std::uint64_t GetTicksRemaining() override { return ticks_left; }

    std::uint64_t GetCNTPCT() override { return 0; }
};

void EmitCopyProgram(Env& env) {
    env.code_mem = {
        0xf9400046,  // LDR X6, [X2]
        0xf9000066,  // STR X6, [X3]
        0x14000000,  // B .
    };
}

void RunCopy(Dynarmic::A64::Jit& jit, Env& env, u64 source, u64 dest) {
    jit.SetPC(0);
    jit.SetRegister(2, source);
    jit.SetRegister(3, dest);
    jit.SetRegister(6, 0);
    env.ticks_left = 3;
    jit.Run();
}

u64 ReadFastmem64(const MmapFastmemArena& arena, u64 vaddr) {
    u64 value;
    std::memcpy(&value, arena.data() + vaddr, sizeof(value));
    return value;
}

void WriteFastmem64(MmapFastmemArena& arena, u64 vaddr, u64 value) {
    std::memcpy(arena.data() + vaddr, &value, sizeof(value));
}

Dynarmic::A64::UserConfig GetFastmemConfig(Env& env,
                                           MmapFastmemArena& fastmem) {
    Dynarmic::A64::UserConfig conf{};
    conf.callbacks = &env;
    conf.fastmem_pointer = reinterpret_cast<std::uintptr_t>(fastmem.data());
    conf.fastmem_address_space_bits = address_space_bits;
    conf.silently_mirror_fastmem = false;
    return conf;
}

void TestFastmemHit() {
    Env env;
    EmitCopyProgram(env);
    MmapFastmemArena fastmem{memory_size};
    WriteFastmem64(fastmem, source_addr, test_value);

    Dynarmic::A64::Jit jit{GetFastmemConfig(env, fastmem)};
    RunCopy(jit, env, source_addr, dest_addr);

    Check(jit.GetRegister(6) == test_value, "fastmem hit loaded wrong value");
    Check(ReadFastmem64(fastmem, dest_addr) == test_value,
          "fastmem hit stored wrong value");
    Check(env.read_callbacks == 0, "fastmem hit used read callback");
    Check(env.write_callbacks == 0, "fastmem hit used write callback");
}

void TestReadFaultFallback() {
    Env env;
    EmitCopyProgram(env);
    MmapFastmemArena fastmem{memory_size};
    env.Write(fault_read_addr, test_value);
    fastmem.ProtectNoAccess(fault_read_addr);

    Dynarmic::A64::Jit jit{GetFastmemConfig(env, fastmem)};
    RunCopy(jit, env, fault_read_addr, dest_addr);

    fastmem.ProtectReadWrite(fault_read_addr);
    Check(jit.GetRegister(6) == test_value,
          "read fault fallback loaded wrong value");
    Check(ReadFastmem64(fastmem, dest_addr) == test_value,
          "read fault fallback stored wrong value");
    Check(env.read_callbacks == 1, "read fault did not use read callback");
    Check(env.write_callbacks == 0,
          "read fault unexpectedly used write callback");
}

void TestWriteFaultFallback() {
    Env env;
    EmitCopyProgram(env);
    MmapFastmemArena fastmem{memory_size};
    WriteFastmem64(fastmem, source_addr, test_value);
    fastmem.ProtectNoAccess(fault_write_addr);

    Dynarmic::A64::Jit jit{GetFastmemConfig(env, fastmem)};
    RunCopy(jit, env, source_addr, fault_write_addr);

    fastmem.ProtectReadWrite(fault_write_addr);
    Check(jit.GetRegister(6) == test_value,
          "write fault fallback loaded wrong value");
    Check(env.Read<u64>(fault_write_addr) == test_value,
          "write fault fallback wrote wrong value");
    Check(env.read_callbacks == 0, "write fault unexpectedly used read callback");
    Check(env.write_callbacks == 1, "write fault did not use write callback");
}

}  // namespace

int main() {
    std::puts("A64 fastmem fault test");
    TestFastmemHit();
    std::puts("  fastmem hit: passed");
    TestReadFaultFallback();
    std::puts("  read fault fallback: passed");
    TestWriteFaultFallback();
    std::puts("  write fault fallback: passed");
    return 0;
}
