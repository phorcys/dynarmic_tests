// A32 minimal reproducer:
// real LDREXH sequence on normal memory.
#include "test_syscall.h"

typedef unsigned short u16;
typedef unsigned int u32;

static __attribute__((noinline)) u32 exclusive_load_half(u16* slot) {
    register u32 addr __asm__("r0") = (u32)(unsigned long)slot;
    register u32 loaded __asm__("r1");

    __asm__ volatile(
        "ldrexh %[loaded], [%[addr]]\n"
        : [loaded] "=&r"(loaded)
        : [addr] "r"(addr)
        : "cc", "memory");

    return loaded;
}

int test_main(void) {
    u16 slot = 0x5AA5u;
    const u32 result = exclusive_load_half(&slot);

    TEST_ASSERT(slot == 0x5AA5u);
    TEST_ASSERT(result == 0x5AA5u);

    test_pass();
    return 0;
}
