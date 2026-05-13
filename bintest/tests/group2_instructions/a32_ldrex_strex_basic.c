// A32 minimal reproducer:
// real LDREX/STREX sequence on normal memory.
#include "test_syscall.h"

typedef unsigned int u32;

static __attribute__((noinline)) u32 exclusive_increment(u32* slot, u32* status_out) {
    register u32 addr __asm__("r0") = (u32)(unsigned long)slot;
    register u32 loaded __asm__("r1");
    register u32 status __asm__("r2");
    register u32 desired __asm__("r3");

    __asm__ volatile(
        "ldrex %[loaded], [%[addr]]\n"
        "add %[desired], %[loaded], #1\n"
        "strex %[status], %[desired], [%[addr]]\n"
        : [loaded] "=&r"(loaded), [status] "=&r"(status), [desired] "=&r"(desired)
        : [addr] "r"(addr)
        : "cc", "memory");

    *status_out = status;
    return desired;
}

int test_main(void) {
    u32 slot = 0x1234u;
    u32 status = 0xFFFFFFFFu;
    const u32 result = exclusive_increment(&slot, &status);

    TEST_ASSERT(status == 0u);
    TEST_ASSERT(slot == 0x1235u);
    TEST_ASSERT(result == 0x1235u);

    test_pass();
    return 0;
}
