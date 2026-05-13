// Minimal test - verify basic syscall functionality
// Tests that we can make syscalls and get correct results

#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing basic syscalls...\n");
    
    // Test 1: getpid syscall (should return a positive number)
    long pid = syscall0(SYS_GETPID);
    test_printstr("  getpid: ");
    test_printint(pid);
    TEST_ASSERT(pid > 0);
    test_printstr(" OK\n");
    
    // Test 2: write syscall (should return the number of bytes written)
    const char *msg = "hello";
    long ret = sys_write(STDOUT, msg, 5);
    test_printstr("\n  write: ");
    test_printint(ret);
    TEST_ASSERT(ret == 5);
    test_printstr(" OK\n");
    
    test_printstr("All basic syscall tests passed!\n");
    test_pass();
    return 0;
}
