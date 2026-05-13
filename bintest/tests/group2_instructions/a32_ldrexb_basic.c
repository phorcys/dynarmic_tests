// A32 minimal reproducer:
// real LDREXB sequence on normal memory.
#include "test_syscall.h"

typedef unsigned char u8;
typedef unsigned int u32;

static __attribute__((noinline)) u32 exclusive_load_byte(u8* slot) {
    register u32 addr __asm__("r0") = (u32)(unsigned long)slot;
    register u32 loaded __asm__("r1");

    __asm__ volatile(
        "ldrexb %[loaded], [%[addr]]\n"
        : [loaded] "=&r"(loaded)
        : [addr] "r"(addr)
        : "cc", "memory");

    return loaded;
}

int test_main(void) {
    u8 slot = 0x5Au;
    const u32 result = exclusive_load_byte(&slot);

    TEST_ASSERT(slot == 0x5Au);
    TEST_ASSERT(result == 0x5Au);

    test_pass();
    return 0;
}
