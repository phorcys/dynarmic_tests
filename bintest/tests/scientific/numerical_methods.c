/*
 * Numerical Methods Test
 * Tests numerical algorithms: interpolation, integration, root finding
 */

#include "test_syscall.h"

/* Simple absolute value */
static float my_fabsf(float x) {
    return x < 0 ? -x : x;
}

/* Square root using Newton-Raphson */
static float my_sqrtf(float x) {
    if (x <= 0) return 0;
    float guess = x / 2.0f;
    for (int i = 0; i < 20; i++) {
        float new_guess = (guess + x / guess) / 2.0f;
        if (my_fabsf(new_guess - guess) < 1e-6f) break;
        guess = new_guess;
    }
    return guess;
}

/* Power function (integer exponent) */
static float my_powi(float base, int exp) {
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

/* Natural log using Taylor series (for x near 1) */
static float my_logf(float x) {
    if (x <= 0) return -1e30f;
    
    /* Normalize to range [0.5, 2] */
    int k = 0;
    while (x > 2.0f) { x /= 2.0f; k++; }
    while (x < 0.5f) { x *= 2.0f; k--; }
    
    /* Taylor series for ln(1+u) where u = x-1 */
    float u = x - 1.0f;
    float result = 0.0f;
    float u_power = u;
    
    for (int n = 1; n <= 20; n++) {
        float term = u_power / n;
        if (n % 2 == 1) result += term;
        else result -= term;
        u_power *= u;
        if (my_fabsf(term) < 1e-7f) break;
    }
    
    /* Add ln(2) * k */
    result += 0.69314718f * k;
    return result;
}

/* Exponential using Taylor series */
static float my_expf(float x) {
    if (x < -20.0f) return 0.0f;
    if (x > 20.0f) return 1e9f;
    
    float result = 1.0f;
    float term = 1.0f;
    
    for (int n = 1; n <= 30; n++) {
        term *= x / n;
        result += term;
        if (my_fabsf(term) < 1e-7f) break;
    }
    
    return result;
}

/* Sine using Taylor series */
static float my_sinf(float x) {
    /* Normalize to [-pi, pi] */
    while (x > 3.14159265f) x -= 6.28318530f;
    while (x < -3.14159265f) x += 6.28318530f;
    
    float x2 = x * x;
    float result = x;
    float term = x;
    
    for (int n = 1; n <= 15; n++) {
        term *= -x2 / ((2*n) * (2*n + 1));
        result += term;
        if (my_fabsf(term) < 1e-7f) break;
    }
    
    return result;
}

/* Cosine using Taylor series */
static float my_cosf(float x) {
    return my_sinf(x + 1.57079632f);
}

/* Linear interpolation */
static float lerp(float a, float b, float t) {
    return a + t * (b - a);
}

/* Bisection root finding */
static float bisect_root(float (*f)(float), float a, float b, int max_iter) {
    float fa = f(a);
    
    for (int i = 0; i < max_iter; i++) {
        float mid = (a + b) / 2.0f;
        float fmid = f(mid);
        
        if (my_fabsf(fmid) < 1e-6f) return mid;
        
        if (fa * fmid < 0) {
            b = mid;
        } else {
            a = mid;
            fa = fmid;
        }
    }
    
    return (a + b) / 2.0f;
}

/* Test square root */
static int test_sqrt(void) {
    test_printstr("Testing sqrt...\n");
    
    TEST_ASSERT(my_fabsf(my_sqrtf(4.0f) - 2.0f) < 0.001f);
    TEST_ASSERT(my_fabsf(my_sqrtf(9.0f) - 3.0f) < 0.001f);
    TEST_ASSERT(my_fabsf(my_sqrtf(2.0f) - 1.414f) < 0.01f);
    TEST_ASSERT(my_fabsf(my_sqrtf(0.25f) - 0.5f) < 0.001f);
    
    test_printstr("  Sqrt: PASS\n");
    return 0;
}

/* Test power */
static int test_power(void) {
    test_printstr("Testing power...\n");
    
    TEST_ASSERT(my_fabsf(my_powi(2.0f, 3) - 8.0f) < 0.001f);
    TEST_ASSERT(my_fabsf(my_powi(2.0f, 10) - 1024.0f) < 0.001f);
    TEST_ASSERT(my_fabsf(my_powi(3.0f, 4) - 81.0f) < 0.001f);
    TEST_ASSERT(my_fabsf(my_powi(2.0f, -2) - 0.25f) < 0.001f);
    
    test_printstr("  Power: PASS\n");
    return 0;
}

/* Test trigonometry */
static int test_trig(void) {
    test_printstr("Testing trig...\n");
    
    TEST_ASSERT(my_fabsf(my_sinf(0.0f) - 0.0f) < 0.001f);
    TEST_ASSERT(my_fabsf(my_sinf(1.5708f) - 1.0f) < 0.01f);
    TEST_ASSERT(my_fabsf(my_cosf(0.0f) - 1.0f) < 0.001f);
    TEST_ASSERT(my_fabsf(my_cosf(3.1416f) - (-1.0f)) < 0.01f);
    
    /* sin^2 + cos^2 = 1 */
    float x = 0.7f;
    float s = my_sinf(x);
    float c = my_cosf(x);
    TEST_ASSERT(my_fabsf(s*s + c*c - 1.0f) < 0.01f);
    
    test_printstr("  Trig: PASS\n");
    return 0;
}

/* Test logarithm and exponential */
static int test_log_exp(void) {
    test_printstr("Testing log/exp...\n");
    
    TEST_ASSERT(my_fabsf(my_logf(1.0f) - 0.0f) < 0.01f);
    TEST_ASSERT(my_fabsf(my_logf(2.71828f) - 1.0f) < 0.05f);
    TEST_ASSERT(my_fabsf(my_expf(0.0f) - 1.0f) < 0.001f);
    TEST_ASSERT(my_fabsf(my_expf(1.0f) - 2.71828f) < 0.05f);
    
    /* exp(log(x)) = x */
    float val = 5.0f;
    float result = my_expf(my_logf(val));
    TEST_ASSERT(my_fabsf(result - val) < 0.1f);
    
    test_printstr("  Log/exp: PASS\n");
    return 0;
}

/* Test interpolation */
static int test_interpolation(void) {
    test_printstr("Testing interpolation...\n");
    
    TEST_ASSERT(my_fabsf(lerp(0.0f, 10.0f, 0.5f) - 5.0f) < 0.001f);
    TEST_ASSERT(my_fabsf(lerp(0.0f, 10.0f, 0.0f) - 0.0f) < 0.001f);
    TEST_ASSERT(my_fabsf(lerp(0.0f, 10.0f, 1.0f) - 10.0f) < 0.001f);
    TEST_ASSERT(my_fabsf(lerp(-5.0f, 5.0f, 0.5f) - 0.0f) < 0.001f);
    
    test_printstr("  Interpolation: PASS\n");
    return 0;
}

/* Function for root finding: x^2 - 2 = 0 */
static float f_sqrt2(float x) {
    return x * x - 2.0f;
}

/* Test root finding */
static int test_root_finding(void) {
    test_printstr("Testing root finding...\n");
    
    float root = bisect_root(f_sqrt2, 1.0f, 2.0f, 50);
    TEST_ASSERT(my_fabsf(root - 1.414f) < 0.01f);
    
    test_printstr("  Root finding: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Numerical Methods Tests ===\n");
    
    test_sqrt();
    test_power();
    test_trig();
    test_log_exp();
    test_interpolation();
    test_root_finding();
    
    test_printstr("All numerical tests passed!\n");
    test_pass();
    return 0;
}
