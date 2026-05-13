// Simple test to verify syscall works
#include "test_syscall.h"

int test_main(void) {
    // Test 1: Direct syscall for write
    const char msg[] = "Hello\n";
#if defined(__aarch64__)
    register long x8 __asm__("x8") = 64;  // SYS_WRITE
    register long x0 __asm__("x0") = 1;   // stdout
    register long x1 __asm__("x1") = (long)msg;
    register long x2 __asm__("x2") = 6;
    __asm__ volatile("svc #0" : "+r"(x0) : "r"(x8), "r"(x1), "r"(x2) : "memory");
#elif defined(__arm__)
    register long r7 __asm__("r7") = 4;   // SYS_WRITE
    register long r0 __asm__("r0") = 1;   // stdout
    register long r1 __asm__("r1") = (long)msg;
    register long r2 __asm__("r2") = 6;
    __asm__ volatile("svc #0" : "+r"(r0) : "r"(r7), "r"(r1), "r"(r2) : "memory");
#else
#error "Unsupported architecture"
#endif

    // Test 2: Exit with success
    test_printstr("World\n");
    
    test_pass();
    return 0;
}
