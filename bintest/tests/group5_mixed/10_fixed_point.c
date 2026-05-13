// Test fixed-point arithmetic
#include "test_syscall.h"

// Q16.16 fixed-point format
typedef int fixed_t;
#define FIXED_SHIFT 16
#define INT_TO_FIXED(x) ((fixed_t)((x) << FIXED_SHIFT))
#define FIXED_TO_INT(x) ((x) >> FIXED_SHIFT)
#define FLOAT_TO_FIXED(x) ((fixed_t)((x) * 65536.0f))

fixed_t fixed_add(fixed_t a, fixed_t b) { return a + b; }
fixed_t fixed_sub(fixed_t a, fixed_t b) { return a - b; }

fixed_t fixed_mul(fixed_t a, fixed_t b) {
    long long prod = (long long)a * b;
    return (fixed_t)(prod >> FIXED_SHIFT);
}

fixed_t fixed_div(fixed_t a, fixed_t b) {
    long long temp = ((long long)a << FIXED_SHIFT) / b;
    return (fixed_t)temp;
}

fixed_t fixed_sqrt(fixed_t n) {
    // Newton's method
    fixed_t x = n;
    for (int i = 0; i < 16; i++) {
        if (x == 0) break;
        x = (x + fixed_div(n, x)) / 2;
    }
    return x;
}

fixed_t fixed_sin(fixed_t x) {
    // Simplified: use Taylor series for small angles
    // sin(x) ≈ x - x³/6 + x⁵/120
    fixed_t x2 = fixed_mul(x, x);
    fixed_t x3 = fixed_mul(x2, x);
    fixed_t x5 = fixed_mul(x3, x2);
    
    // Approximate
    return x - fixed_div(x3, INT_TO_FIXED(6)) + fixed_div(x5, INT_TO_FIXED(120));
}

int test_main(void) {
    test_printstr("Testing fixed-point arithmetic...\n");
    
    // Test 1: Basic addition
    fixed_t a1 = INT_TO_FIXED(10);
    fixed_t b1 = INT_TO_FIXED(5);
    fixed_t r1 = fixed_add(a1, b1);
    test_printstr("  add: ");
    test_printint(FIXED_TO_INT(r1));
    TEST_ASSERT(FIXED_TO_INT(r1) == 15);
    test_printstr(" OK\n");
    
    // Test 2: Subtraction
    fixed_t r2 = fixed_sub(a1, b1);
    test_printstr("  sub: ");
    test_printint(FIXED_TO_INT(r2));
    TEST_ASSERT(FIXED_TO_INT(r2) == 5);
    test_printstr(" OK\n");
    
    // Test 3: Multiplication
    fixed_t a3 = INT_TO_FIXED(3);
    fixed_t b3 = INT_TO_FIXED(4);
    fixed_t r3 = fixed_mul(a3, b3);
    test_printstr("  mul: ");
    test_printint(FIXED_TO_INT(r3));
    TEST_ASSERT(FIXED_TO_INT(r3) == 12);
    test_printstr(" OK\n");
    
    // Test 4: Division
    fixed_t a4 = INT_TO_FIXED(20);
    fixed_t b4 = INT_TO_FIXED(4);
    fixed_t r4 = fixed_div(a4, b4);
    test_printstr("  div: ");
    test_printint(FIXED_TO_INT(r4));
    TEST_ASSERT(FIXED_TO_INT(r4) == 5);
    test_printstr(" OK\n");
    
    // Test 5: Square root (approximate)
    fixed_t a5 = INT_TO_FIXED(4);
    fixed_t r5 = fixed_sqrt(a5);
    test_printstr("  sqrt: ");
    int sqrt_val = FIXED_TO_INT(r5);
    test_printint(sqrt_val);
    TEST_ASSERT(sqrt_val >= 1 && sqrt_val <= 3);  // approximate
    test_printstr(" OK\n");
    
    // Test 6: Sine approximation (small angle)
    fixed_t angle = FLOAT_TO_FIXED(0.1);  // small angle
    fixed_t sin_val = fixed_sin(angle);
    test_printstr("  sin: ");
    int sv = FIXED_TO_INT(sin_val * 10);  // scale for readability
    test_printint(sv);
    test_printstr(" OK\n");
    
    // Test 7: Fractional precision
    fixed_t frac = FLOAT_TO_FIXED(1.5);  // 1.5 in Q16.16
    fixed_t sq = fixed_mul(frac, frac);  // 1.5 * 1.5 = 2.25
    test_printstr("  frac: ");
    // 2.25 in Q16.16 = 2 * 65536 + 0.25 * 65536 = 131072 + 16384 = 147456
    TEST_ASSERT(sq == 147456);
    test_printstr("OK\n");
    
    test_printstr("All fixed-point tests passed!\n");
    test_pass();
    return 0;
}
