// Test numerical algorithms
#include "test_syscall.h"

int abs_val(int x) {
    return (x < 0) ? -x : x;
}

int sign(int x) {
    return (x > 0) ? 1 : (x < 0) ? -1 : 0;
}

int clamp(int x, int lo, int hi) {
    if (x < lo) return lo;
    if (x > hi) return hi;
    return x;
}

int lerp(int a, int b, int t) {
    // Linear interpolation: a + t * (b - a) / 100
    return a + t * (b - a) / 100;
}

int test_main(void) {
    test_printstr("Testing numerical algorithms...\n");
    
    // Test 1: Absolute value
    TEST_ASSERT(abs_val(-5) == 5);
    TEST_ASSERT(abs_val(5) == 5);
    TEST_ASSERT(abs_val(0) == 0);
    test_printstr("  abs: OK\n");
    
    // Test 2: Sign function
    TEST_ASSERT(sign(-10) == -1);
    TEST_ASSERT(sign(0) == 0);
    TEST_ASSERT(sign(10) == 1);
    test_printstr("  sign: OK\n");
    
    // Test 3: Clamp
    int c = clamp(5, 0, 10);
    test_printstr("  clamp(5, 0, 10): ");
    test_printint(c);
    TEST_ASSERT(c == 5);
    
    c = clamp(-5, 0, 10);
    test_printstr("\n  clamp(-5, 0, 10): ");
    test_printint(c);
    TEST_ASSERT(c == 0);
    
    c = clamp(15, 0, 10);
    test_printstr("\n  clamp(15, 0, 10): ");
    test_printint(c);
    TEST_ASSERT(c == 10);
    
    // Test 4: Linear interpolation
    int l = lerp(0, 100, 50);
    test_printstr("\n  lerp(0, 100, 50): ");
    test_printint(l);
    TEST_ASSERT(l == 50);
    
    test_printstr("\nAll numerical tests passed!\n");
    test_pass();
    return 0;
}
