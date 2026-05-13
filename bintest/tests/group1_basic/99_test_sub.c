#include "test_syscall.h"

int simple_sub(int a, int b) {
    return a - b;
}

int test_main(void) {
    test_printstr("Test simple subtraction...\n");
    
    int r = simple_sub(100, 42);
    test_printstr("  100 - 42 = ");
    test_printint(r);
    test_printstr("\n");
    TEST_ASSERT(r == 58);
    
    test_pass();
    return 0;
}
