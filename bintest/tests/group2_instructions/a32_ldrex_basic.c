// A32 minimal reproducer:
// real LDREX sequence on normal memory.
#include "test_syscall.h"

typedef unsigned int u32;

static __attribute__((noinline)) u32 exclusive_load(u32* slot) {
    register u32 addr __asm__("r0") = (u32)(unsigned long)slot;
    register u32 loaded __asm__("r1");

    __asm__ volatile(
        "ldrex %[loaded], [%[addr]]\n"
        : [loaded] "=&r"(loaded)
        : [addr] "r"(addr)
        : "cc", "memory");

    return loaded;
}

int test_main(void) {
    u32 slot = 0x1234u;
    const u32 result = exclusive_load(&slot);

    TEST_ASSERT(slot == 0x1234u);
    TEST_ASSERT(result == 0x1234u);

    test_pass();
    return 0;
}
