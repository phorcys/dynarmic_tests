// Test Fibonacci sequence
#include "test_syscall.h"

int fib_iter(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    int a = 0, b = 1;
    for (int i = 2; i <= n; i++) {
        int temp = a + b;
        a = b;
        b = temp;
    }
    return b;
}

int test_main(void) {
    test_printstr("Testing Fibonacci...\n");
    
    // Test 1: Basic Fibonacci
    int f0 = fib_iter(0);
    int f1 = fib_iter(1);
    int f2 = fib_iter(2);
    int f3 = fib_iter(3);
    
    test_printstr("  fib(0,1,2,3): ");
    test_printint(f0);
    test_printstr(" ");
    test_printint(f1);
    test_printstr(" ");
    test_printint(f2);
    test_printstr(" ");
    test_printint(f3);
    test_printstr("\n");
    
    TEST_ASSERT(f0 == 0);
    TEST_ASSERT(f1 == 1);
    TEST_ASSERT(f2 == 1);
    TEST_ASSERT(f3 == 2);
    
    // Test 2: More Fibonacci
    int f10 = fib_iter(10);
    test_printstr("  fib(10) = ");
    test_printint(f10);
    TEST_ASSERT(f10 == 55);
    
    int f20 = fib_iter(20);
    test_printstr("\n  fib(20) = ");
    test_printint(f20);
    TEST_ASSERT(f20 == 6765);
    
    test_printstr("\nAll Fibonacci tests passed!\n");
    test_pass();
    return 0;
}
