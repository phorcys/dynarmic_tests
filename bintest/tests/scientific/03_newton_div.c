// Newton's Method for Division Test
// Tests: Division using Newton-Raphson iteration
#include "test_syscall.h"

double abs_d(double x) {
    return x < 0 ? -x : x;
}

// Newton's method for 1/a: x_{n+1} = x_n * (2 - a * x_n)
double reciprocal(double a, int iterations) {
    // Initial approximation using exponent manipulation
    // For a = m * 2^e, 1/a ≈ 2^{-e} / m ≈ 2^{-e}
    // We use a rough approximation: 1/a ≈ 1/(nearest power of 2)
    double abs_a = a < 0 ? -a : a;
    double x = 1.0;
    
    // Rough initial guess: scale to near 1, then invert
    while (abs_a > 2.0) { x *= 0.5; abs_a *= 0.5; }
    while (abs_a < 1.0) { x *= 2.0; abs_a *= 2.0; }
    x = x / abs_a;  // Initial guess
    
    // Newton-Raphson iterations
    for (int i = 0; i < iterations; i++) {
        x = x * (2.0 - a * x);
    }
    
    return x;
}

double newton_divide(double dividend, double divisor, int iterations) {
    double r = reciprocal(divisor, iterations);
    return dividend * r;
}

int approx_equal(double a, double b, double eps) {
    return abs_d(a - b) < eps;
}

int test_main(void) {
    test_printstr("Testing Newton Division...\n");
    
    // Test 1: 10 / 2 = 5
    double r1 = newton_divide(10.0, 2.0, 5);
    test_printstr("  div2: ");
    test_printint((int)(r1 + 0.5));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(r1, 5.0, 0.01));
    test_printstr("OK\n");
    
    // Test 2: 100 / 4 = 25
    double r2 = newton_divide(100.0, 4.0, 5);
    test_printstr("  div4: ");
    test_printint((int)(r2 + 0.5));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(r2, 25.0, 0.01));
    test_printstr("OK\n");
    
    // Test 3: 1 / 3 ≈ 0.333
    double r3 = newton_divide(1.0, 3.0, 10);
    test_printstr("  div3: ");
    test_printint((int)(r3 * 100));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(r3, 0.333, 0.01));
    test_printstr("OK\n");
    
    // Test 4: 22 / 7 ≈ 3.1429
    double r4 = newton_divide(22.0, 7.0, 10);
    test_printstr("  pi_approx: ");
    test_printint((int)(r4 * 1000));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(r4, 3.1429, 0.01));
    test_printstr("OK\n");
    
    // Test 5: Convergence test (more iterations should give good precision)
    double r5 = newton_divide(1.0, 7.0, 10);
    double exact = 1.0 / 7.0;
    
    test_printstr("  converge: ");
    test_printstr("result=");
    test_printint((int)(r5 * 10000));
    test_printstr(" exact=");
    test_printint((int)(exact * 10000));
    // Just check we're within 1% of exact value
    TEST_ASSERT(approx_equal(r5, exact, 0.01));
    test_printstr("OK\n");
    
    test_printstr("All Newton Division tests passed!\n");
    test_pass();
    return 0;
}
