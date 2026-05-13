// Test callback functions
#include "test_syscall.h"

typedef int (*int_callback)(int);

static int callback_count = 0;

int double_it(int x) {
    return x * 2;
}

int square_it(int x) {
    return x * x;
}

int apply(int_callback cb, int value) {
    return cb(value);
}

int test_main(void) {
    test_printstr("Testing callbacks...\n");
    
    int r1 = apply(double_it, 5);
    test_printstr("  double_it(5): ");
    test_printint(r1);
    TEST_ASSERT(r1 == 10);
    
    int r2 = apply(square_it, 7);
    test_printstr("\n  square_it(7): ");
    test_printint(r2);
    TEST_ASSERT(r2 == 49);
    
    test_printstr("\nAll callback tests passed!\n");
    test_pass();
    return 0;
}