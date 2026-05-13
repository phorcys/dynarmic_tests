// Test factorial calculations
#include "test_syscall.h"

int factorial_iter(int n) {
    int result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

int factorial_rec(int n) {
    if (n <= 1) return 1;
    return n * factorial_rec(n - 1);
}

long long factorial64(int n) {
    long long result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

int falling_factorial(int n, int k) {
    // n * (n-1) * ... * (n-k+1)
    int result = 1;
    for (int i = 0; i < k; i++) {
        result *= (n - i);
    }
    return result;
}

int test_main(void) {
    test_printstr("Testing factorial...\n");
    
    // Test 1: Small factorials
    int f1 = factorial_iter(5);
    test_printstr("  5! = ");
    test_printint(f1);
    TEST_ASSERT(f1 == 120);
    
    // Test 2: 0! and 1!
    TEST_ASSERT(factorial_iter(0) == 1);
    TEST_ASSERT(factorial_iter(1) == 1);
    test_printstr("\n  0! = 1, 1! = 1: OK\n");
    
    // Test 3: Recursive vs iterative
    for (int i = 0; i <= 10; i++) {
        TEST_ASSERT(factorial_iter(i) == factorial_rec(i));
    }
    test_printstr("  iter == rec: OK\n");
    
    // Test 4: 64-bit factorial
    long long f10 = factorial64(10);
    test_printstr("  10! = ");
    test_printint((int)f10);
    TEST_ASSERT(f10 == 3628800);
    
    long long f12 = factorial64(12);
    test_printstr("\n  12! = ");
    test_printint((int)f12);
    TEST_ASSERT(f12 == 479001600);
    
    // Test 5: Falling factorial
    int ff = falling_factorial(7, 3);
    test_printstr("\n  (7)_3 = ");
    test_printint(ff);
    TEST_ASSERT(ff == 210);  // 7*6*5 = 210
    
    test_printstr("\nAll factorial tests passed!\n");
    test_pass();
    return 0;
}
