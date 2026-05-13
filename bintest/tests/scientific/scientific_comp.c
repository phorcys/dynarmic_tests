/*
 * Scientific Computation Test
 * Tests numerical algorithms
 */

#include "test_syscall.h"

/* Newton's method for square root */
static float sqrt_newton(float x, int iterations) {
    if (x <= 0.0f) return 0.0f;
    float guess = x * 0.5f;
    for (int i = 0; i < iterations; i++) {
        guess = 0.5f * (guess + x / guess);
    }
    return guess;
}

/* Fast inverse square root (Quake style) */
static float fast_inv_sqrt(float x) {
    float x2 = x * 0.5f;
    int i = *(int*)&x;
    i = 0x5f3759df - (i >> 1);
    float y = *(float*)&i;
    y = y * (1.5f - (x2 * y * y));
    return y;
}

/* Simple power function */
static float power(float base, int exp) {
    float result = 1.0f;
    int neg = exp < 0;
    if (neg) exp = -exp;
    
    while (exp > 0) {
        if (exp & 1) result *= base;
        base *= base;
        exp >>= 1;
    }
    return neg ? 1.0f / result : result;
}

/* Factorial */
static uint64_t factorial(int n) {
    uint64_t result = 1;
    for (int i = 2; i <= n && i <= 20; i++) {
        result *= i;
    }
    return result;
}

/* Fibonacci */
static uint64_t fibonacci(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    
    uint64_t a = 0, b = 1;
    for (int i = 2; i <= n; i++) {
        uint64_t c = a + b;
        a = b;
        b = c;
    }
    return b;
}

/* Test square root */
static int test_sqrt(void) {
    test_printstr("Testing sqrt...\n");
    
    TEST_ASSERT(sqrt_newton(4.0f, 10) > 1.99f && sqrt_newton(4.0f, 10) < 2.01f);
    TEST_ASSERT(sqrt_newton(9.0f, 10) > 2.99f && sqrt_newton(9.0f, 10) < 3.01f);
    TEST_ASSERT(sqrt_newton(16.0f, 10) > 3.99f && sqrt_newton(16.0f, 10) < 4.01f);
    TEST_ASSERT(sqrt_newton(1.0f, 10) > 0.99f && sqrt_newton(1.0f, 10) < 1.01f);
    
    test_printstr("  Sqrt: PASS\n");
    return 0;
}

/* Test fast inverse sqrt */
static int test_inv_sqrt(void) {
    test_printstr("Testing inv sqrt...\n");
    
    float inv = fast_inv_sqrt(4.0f);
    /* 1/sqrt(4) = 0.5 */
    TEST_ASSERT(inv > 0.4f && inv < 0.6f);
    
    inv = fast_inv_sqrt(1.0f);
    /* 1/sqrt(1) = 1.0 */
    TEST_ASSERT(inv > 0.9f && inv < 1.1f);
    
    test_printstr("  Inv sqrt: PASS\n");
    return 0;
}

/* Test power function */
static int test_power(void) {
    test_printstr("Testing power...\n");
    
    TEST_ASSERT(power(2.0f, 0) == 1.0f);
    TEST_ASSERT(power(2.0f, 1) == 2.0f);
    TEST_ASSERT(power(2.0f, 2) == 4.0f);
    TEST_ASSERT(power(2.0f, 10) == 1024.0f);
    TEST_ASSERT(power(10.0f, 3) == 1000.0f);
    
    /* Negative exponent */
    TEST_ASSERT(power(2.0f, -1) == 0.5f);
    TEST_ASSERT(power(4.0f, -1) == 0.25f);
    
    test_printstr("  Power: PASS\n");
    return 0;
}

/* Test factorial */
static int test_factorial(void) {
    test_printstr("Testing factorial...\n");
    
    TEST_ASSERT(factorial(0) == 1);
    TEST_ASSERT(factorial(1) == 1);
    TEST_ASSERT(factorial(5) == 120);
    TEST_ASSERT(factorial(10) == 3628800);
    
    test_printstr("  Factorial: PASS\n");
    return 0;
}

/* Test Fibonacci */
static int test_fibonacci(void) {
    test_printstr("Testing fibonacci...\n");
    
    TEST_ASSERT(fibonacci(0) == 0);
    TEST_ASSERT(fibonacci(1) == 1);
    TEST_ASSERT(fibonacci(2) == 1);
    TEST_ASSERT(fibonacci(10) == 55);
    TEST_ASSERT(fibonacci(20) == 6765);
    
    test_printstr("  Fibonacci: PASS\n");
    return 0;
}

/* Test numerical integration (trapezoidal rule) */
static int test_integration(void) {
    test_printstr("Testing integration...\n");
    
    /* Integrate f(x) = x from 0 to 1, should be 0.5 */
    float sum = 0.0f;
    int n = 100;
    float dx = 1.0f / n;
    for (int i = 0; i < n; i++) {
        float x0 = i * dx;
        float x1 = (i + 1) * dx;
        sum += (x0 + x1) * 0.5f * dx;
    }
    TEST_ASSERT(sum > 0.49f && sum < 0.51f);
    
    test_printstr("  Integration: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Scientific Computation Tests ===\n");
    
    test_sqrt();
    test_inv_sqrt();
    test_power();
    test_factorial();
    test_fibonacci();
    test_integration();
    
    test_printstr("All scientific computation tests passed!\n");
    test_pass();
    return 0;
}
