/* Test: Recursive function calls */
#include "test_syscall.h"

// Recursive factorial
static long factorial(long n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

// Recursive Fibonacci (inefficient but tests recursion)
static long fib(long n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}

// Recursive sum
static long sum_to_n(long n) {
    if (n <= 0) return 0;
    return n + sum_to_n(n - 1);
}

int test_main(void) {
    test_printstr("Testing recursive calls...\n");
    
    // Factorial
    long f5 = factorial(5);
    TEST_ASSERT(f5 == 120);
    test_printstr("  5! = ");
    test_printint(f5);
    test_newline();
    
    long f6 = factorial(6);
    TEST_ASSERT(f6 == 720);
    test_printstr("  6! = ");
    test_printint(f6);
    test_newline();
    
    // Fibonacci
    long fib10 = fib(10);
    TEST_ASSERT(fib10 == 55);
    test_printstr("  fib(10) = ");
    test_printint(fib10);
    test_newline();
    
    // Sum
    long sum10 = sum_to_n(10);
    TEST_ASSERT(sum10 == 55);
    test_printstr("  sum(1..10) = ");
    test_printint(sum10);
    test_newline();
    
    test_printstr("All recursive tests passed!\n");
    test_pass();
    return 0;
}
