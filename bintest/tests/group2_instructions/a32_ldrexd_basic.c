// A32 minimal reproducer:
// real LDREXD sequence on normal memory.
#include "test_syscall.h"

typedef unsigned int u32;
typedef unsigned long long u64;

static __attribute__((noinline)) u64 exclusive_load_double(u64* slot) {
    register u32 addr __asm__("r0") = (u32)(unsigned long)slot;
    register u32 lo __asm__("r2");
    register u32 hi __asm__("r3");

    __asm__ volatile(
        "ldrexd %[lo], %[hi], [%[addr]]\n"
        : [lo] "=&r"(lo), [hi] "=&r"(hi)
        : [addr] "r"(addr)
        : "cc", "memory");

    return ((u64)hi << 32) | lo;
}

int test_main(void) {
    u64 slot = 0x1122334455667788ULL;
    const u64 result = exclusive_load_double(&slot);

    TEST_ASSERT(slot == 0x1122334455667788ULL);
    TEST_ASSERT(result == 0x1122334455667788ULL);

    test_pass();
    return 0;
}
