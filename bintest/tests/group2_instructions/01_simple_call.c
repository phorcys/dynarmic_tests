/* Test: Simple function call */
#include "test_syscall.h"

// Simple function
static long add(long a, long b) {
    return a + b;
}

// Function with local variables
static long multiply(long a, long b) {
    long result = a * b;
    return result;
}

int test_main(void) {
    test_printstr("Testing simple function calls...\n");
    
    // Call add
    long sum = add(10, 20);
    TEST_ASSERT(sum == 30);
    test_printstr("  add(10, 20) = ");
    test_printint(sum);
    test_newline();
    
    // Call multiply
    long prod = multiply(6, 7);
    TEST_ASSERT(prod == 42);
    test_printstr("  multiply(6, 7) = ");
    test_printint(prod);
    test_newline();
    
    // Chain calls
    long chain = add(multiply(3, 4), multiply(5, 6));
    TEST_ASSERT(chain == 12 + 30);
    test_printstr("  chained = ");
    test_printint(chain);
    test_newline();
    
    test_printstr("All simple call tests passed!\n");
    test_pass();
    return 0;
}
