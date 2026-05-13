// Simple floating point test
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing FP...\n");
    
    // Test 1: Simple addition
    double a = 3.0;
    double b = 4.0;
    double c = a + b;
    test_printstr("  add: ");
    test_printint((int)c);
    test_printstr("\n");
    TEST_ASSERT(c == 7.0);
    
    // Test 2: Multiplication
    double d = 3.0 * 4.0;
    test_printstr("  mul: ");
    test_printint((int)d);
    test_printstr("\n");
    TEST_ASSERT(d == 12.0);
    
    // Test 3: Division
    double e = 15.0 / 3.0;
    test_printstr("  div: ");
    test_printint((int)e);
    test_printstr("\n");
    TEST_ASSERT(e == 5.0);
    
    // Test 4: Square root approximation
    double x = 3.0, y = 4.0;
    double x2 = x * x;  // 9
    double y2 = y * y;  // 16
    double sum = x2 + y2;  // 25
    test_printstr("  sum: ");
    test_printint((int)sum);
    test_printstr("\n");
    
    // Newton's method for sqrt
    double sqrt_val = sum;
    for (int i = 0; i < 10; i++) {
        sqrt_val = 0.5 * (sqrt_val + sum / sqrt_val);
    }
    test_printstr("  sqrt: ");
    test_printint((int)sqrt_val);
    test_printstr("\n");
    TEST_ASSERT(sqrt_val > 4.9 && sqrt_val < 5.1);
    
    // Test 5: fabs
    double neg = -5.0;
    double abs_val = neg < 0 ? -neg : neg;
    test_printstr("  abs: ");
    test_printint((int)abs_val);
    test_printstr("\n");
    TEST_ASSERT(abs_val == 5.0);
    
    // Test 6: Compare
    double f1 = 5.0;
    double f2 = 5.0;
    test_printstr("  cmp: ");
    TEST_ASSERT(f1 == f2);
    test_printstr("OK\n");
    
    // Test 7: approx_equal logic
    double v1 = 4.95;
    double v2 = 5.0;
    double diff = v1 - v2;  // -0.05
    if (diff < 0) diff = -diff;  // 0.05
    test_printstr("  diff: ");
    test_printint((int)(diff * 100));
    test_printstr("\n");
    TEST_ASSERT(diff < 0.1);
    
    test_printstr("All FP tests passed!\n");
    test_pass();
    return 0;
}
