// Polynomial Evaluation Test
// Tests: Polynomial evaluation using Horner's method
#include "test_syscall.h"

double poly_eval(double *coeffs, int degree, double x) {
    double result = coeffs[degree];
    for (int i = degree - 1; i >= 0; i--) {
        result = result * x + coeffs[i];
    }
    return result;
}

double abs_d(double x) {
    return x < 0 ? -x : x;
}

int approx_equal(double a, double b, double eps) {
    return abs_d(a - b) < eps;
}

int test_main(void) {
    test_printstr("Testing Polynomial Evaluation...\n");
    
    // Test 1: p(x) = 1 + x + x^2 at x=2
    // 1 + 2 + 4 = 7
    double p1[] = {1, 1, 1};  // coeffs: 1, 1, 1 (constant, x, x^2)
    double r1 = poly_eval(p1, 2, 2.0);
    
    test_printstr("  quad: ");
    test_printint((int)(r1 + 0.5));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(r1, 7.0, 1e-10));
    test_printstr("OK\n");
    
    // Test 2: p(x) = 1 + 2x + 3x^2 at x=1
    // 1 + 2 + 3 = 6
    double p2[] = {1, 2, 3};
    double r2 = poly_eval(p2, 2, 1.0);
    
    test_printstr("  simple: ");
    test_printint((int)(r2 + 0.5));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(r2, 6.0, 1e-10));
    test_printstr("OK\n");
    
    // Test 3: Constant polynomial p(x) = 5
    double p3[] = {5};
    double r3 = poly_eval(p3, 0, 10.0);
    
    test_printstr("  const: ");
    test_printint((int)(r3 + 0.5));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(r3, 5.0, 1e-10));
    test_printstr("OK\n");
    
    // Test 4: Linear polynomial p(x) = 2 + 3x at x=4
    // 2 + 12 = 14
    double p4[] = {2, 3};
    double r4 = poly_eval(p4, 1, 4.0);
    
    test_printstr("  linear: ");
    test_printint((int)(r4 + 0.5));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(r4, 14.0, 1e-10));
    test_printstr("OK\n");
    
    // Test 5: Higher degree polynomial
    // p(x) = 1 + x + x^2 + x^3 + x^4 at x=2
    // 1 + 2 + 4 + 8 + 16 = 31
    double p5[] = {1, 1, 1, 1, 1};
    double r5 = poly_eval(p5, 4, 2.0);
    
    test_printstr("  higher: ");
    test_printint((int)(r5 + 0.5));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(r5, 31.0, 1e-10));
    test_printstr("OK\n");
    
    // Test 6: Negative coefficients
    // p(x) = 1 - x + x^2 at x=3
    // 1 - 3 + 9 = 7
    double p6[] = {1, -1, 1};
    double r6 = poly_eval(p6, 2, 3.0);
    
    test_printstr("  neg: ");
    test_printint((int)(r6 + 0.5));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(r6, 7.0, 1e-10));
    test_printstr("OK\n");
    
    // Test 7: Zero at root
    // p(x) = (x-2)(x-3) = 6 - 5x + x^2 at x=2
    // Should be 0
    double p7[] = {6, -5, 1};
    double r7 = poly_eval(p7, 2, 2.0);
    
    test_printstr("  root: ");
    test_printint((int)(r7 * 1000));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(r7, 0.0, 1e-10));
    test_printstr("OK\n");
    
    test_printstr("All Polynomial tests passed!\n");
    test_pass();
    return 0;
}
