// Test recursion depth and patterns (simplified)
#include "test_syscall.h"

int sum_rec(int n) {
    if (n <= 0) return 0;
    return n + sum_rec(n - 1);
}

int hanoi_moves(int n) {
    if (n == 1) return 1;
    return 2 * hanoi_moves(n - 1) + 1;
}

int binomial(int n, int k) {
    if (k == 0 || k == n) return 1;
    return binomial(n - 1, k - 1) + binomial(n - 1, k);
}

int test_main(void) {
    test_printstr("Testing recursion...\n");
    
    // Test 1: Sum recursion
    int r = sum_rec(50);
    test_printstr("  sum_rec(50) = ");
    test_printint(r);
    TEST_ASSERT(r == 1275);  // 50*51/2
    
    // Test 2: Tower of Hanoi
    r = hanoi_moves(5);
    test_printstr("\n  hanoi(5) = ");
    test_printint(r);
    TEST_ASSERT(r == 31);  // 2^5 - 1
    
    // Test 3: Binomial coefficients
    r = binomial(5, 2);
    test_printstr("\n  C(5,2) = ");
    test_printint(r);
    TEST_ASSERT(r == 10);
    
    r = binomial(7, 3);
    test_printstr("\n  C(7,3) = ");
    test_printint(r);
    TEST_ASSERT(r == 35);
    
    test_printstr("\nAll recursion tests passed!\n");
    test_pass();
    return 0;
}
