// Polynomial Multiplication Test
// Tests: Multiplying two polynomials
#include "test_syscall.h"

#define MAX_DEGREE 20

void poly_multiply(double *a, int deg_a, double *b, int deg_b, double *result) {
    int deg_r = deg_a + deg_b;
    
    // Initialize result to zero
    for (int i = 0; i <= deg_r; i++) {
        result[i] = 0.0;
    }
    
    // Multiply
    for (int i = 0; i <= deg_a; i++) {
        for (int j = 0; j <= deg_b; j++) {
            result[i + j] += a[i] * b[j];
        }
    }
}

double abs_d(double x) {
    return x < 0 ? -x : x;
}

int approx_equal(double a, double b, double eps) {
    return abs_d(a - b) < eps;
}

int test_main(void) {
    test_printstr("Testing Polynomial Multiplication...\n");
    
    // Test 1: (1 + x)(1 + x) = 1 + 2x + x^2
    double a1[] = {1, 1};  // 1 + x
    double b1[] = {1, 1};  // 1 + x
    double r1[MAX_DEGREE];
    
    poly_multiply(a1, 1, b1, 1, r1);
    
    test_printstr("  square: ");
    TEST_ASSERT(approx_equal(r1[0], 1.0, 1e-10));
    TEST_ASSERT(approx_equal(r1[1], 2.0, 1e-10));
    TEST_ASSERT(approx_equal(r1[2], 1.0, 1e-10));
    test_printstr("OK\n");
    
    // Test 2: (1 + x)(1 - x) = 1 - x^2
    double a2[] = {1, 1};   // 1 + x
    double b2[] = {1, -1};  // 1 - x
    double r2[MAX_DEGREE];
    
    poly_multiply(a2, 1, b2, 1, r2);
    
    test_printstr("  diff: ");
    TEST_ASSERT(approx_equal(r2[0], 1.0, 1e-10));
    TEST_ASSERT(approx_equal(r2[1], 0.0, 1e-10));
    TEST_ASSERT(approx_equal(r2[2], -1.0, 1e-10));
    test_printstr("OK\n");
    
    // Test 3: (1 + 2x)(3 + 4x) = 3 + 10x + 8x^2
    double a3[] = {1, 2};
    double b3[] = {3, 4};
    double r3[MAX_DEGREE];
    
    poly_multiply(a3, 1, b3, 1, r3);
    
    test_printstr("  coeffs: ");
    TEST_ASSERT(approx_equal(r3[0], 3.0, 1e-10));
    TEST_ASSERT(approx_equal(r3[1], 10.0, 1e-10));
    TEST_ASSERT(approx_equal(r3[2], 8.0, 1e-10));
    test_printstr("OK\n");
    
    // Test 4: Multiply by constant
    double a4[] = {2, 3, 4};  // 2 + 3x + 4x^2
    double b4[] = {5};       // 5
    double r4[MAX_DEGREE];
    
    poly_multiply(a4, 2, b4, 0, r4);
    
    test_printstr("  const: ");
    TEST_ASSERT(approx_equal(r4[0], 10.0, 1e-10));
    TEST_ASSERT(approx_equal(r4[1], 15.0, 1e-10));
    TEST_ASSERT(approx_equal(r4[2], 20.0, 1e-10));
    test_printstr("OK\n");
    
    // Test 5: Higher degree
    // (x^2 + 1)(x + 1) = x^3 + x^2 + x + 1
    double a5[] = {1, 0, 1};  // 1 + x^2
    double b5[] = {1, 1};     // 1 + x
    double r5[MAX_DEGREE];
    
    poly_multiply(a5, 2, b5, 1, r5);
    
    test_printstr("  higher: ");
    TEST_ASSERT(approx_equal(r5[0], 1.0, 1e-10));
    TEST_ASSERT(approx_equal(r5[1], 1.0, 1e-10));
    TEST_ASSERT(approx_equal(r5[2], 1.0, 1e-10));
    TEST_ASSERT(approx_equal(r5[3], 1.0, 1e-10));
    test_printstr("OK\n");
    
    test_printstr("All Polynomial Multiplication tests passed!\n");
    test_pass();
    return 0;
}
