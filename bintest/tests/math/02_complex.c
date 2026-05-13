// Complex Number Operations Test
// Tests: Complex arithmetic (add, multiply, exp)
#include "test_syscall.h"

typedef struct {
    double re, im;
} complex;

complex c_add(complex a, complex b) {
    complex r = {a.re + b.re, a.im + b.im};
    return r;
}

complex c_sub(complex a, complex b) {
    complex r = {a.re - b.re, a.im - b.im};
    return r;
}

complex c_mul(complex a, complex b) {
    complex r = {a.re * b.re - a.im * b.im, a.re * b.im + a.im * b.re};
    return r;
}

complex c_div(complex a, complex b) {
    double denom = b.re * b.re + b.im * b.im;
    complex r = {(a.re * b.re + a.im * b.im) / denom, 
                 (a.im * b.re - a.re * b.im) / denom};
    return r;
}

double c_abs(complex a) {
    // sqrt(re^2 + im^2) using Newton-Raphson
    double sum = a.re * a.re + a.im * a.im;
    if (sum == 0) return 0;
    
    // Initial guess
    double x = sum;
    double y = sum * 0.5;
    
    // Newton-Raphson iterations: x = (x + sum/x) / 2
    for (int i = 0; i < 10; i++) {
        x = 0.5 * (x + sum / x);
    }
    return x;
}

complex c_exp(complex a) {
    // e^(x+iy) = e^x * (cos(y) + i*sin(y))
    // Use Taylor series for cos/sin
    double x = a.re;
    double y = a.im;
    
    // exp(x) approximation
    double ex = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 20; i++) {
        term *= x / i;
        ex += term;
    }
    
    // cos(y) and sin(y) using Taylor series
    double cos_y = 1.0;
    double sin_y = y;
    double y2 = y * y;
    double cos_term = 1.0;
    double sin_term = y;
    for (int i = 1; i <= 10; i++) {
        cos_term *= -y2 / ((2*i-1) * (2*i));
        sin_term *= -y2 / (2*i * (2*i+1));
        cos_y += cos_term;
        sin_y += sin_term;
    }
    
    complex r = {ex * cos_y, ex * sin_y};
    return r;
}

int approx_equal(double a, double b, double eps) {
    double diff = a - b;
    if (diff < 0) diff = -diff;
    return diff < eps;
}

int c_equals(complex a, complex b, double eps) {
    return approx_equal(a.re, b.re, eps) && approx_equal(a.im, b.im, eps);
}

int test_main(void) {
    test_printstr("Testing Complex Operations...\n");
    
    // Test 1: Addition
    complex a = {3.0, 4.0};
    complex b = {1.0, -2.0};
    complex r1 = c_add(a, b);
    test_printstr("  add: ");
    TEST_ASSERT(approx_equal(r1.re, 4.0, 1e-10) && approx_equal(r1.im, 2.0, 1e-10));
    test_printstr("OK\n");
    
    // Test 2: Multiplication
    // (3+4i) * (1-2i) = 3 - 6i + 4i - 8i^2 = 3 - 2i + 8 = 11 - 2i
    complex r2 = c_mul(a, b);
    test_printstr("  mul: ");
    TEST_ASSERT(approx_equal(r2.re, 11.0, 1e-10) && approx_equal(r2.im, -2.0, 1e-10));
    test_printstr("OK\n");
    
    // Test 3: Division
    // (11-2i) / (1-2i) should give back (3+4i)
    complex r3 = c_div(r2, b);
    test_printstr("  div: ");
    TEST_ASSERT(c_equals(r3, a, 1e-10));
    test_printstr("OK\n");
    
    // Test 4: Absolute value
    // |3+4i| = 5
    double abs_val = c_abs(a);
    test_printstr("  abs: ");
    test_printint((int)(abs_val + 0.5));
    TEST_ASSERT(approx_equal(abs_val, 5.0, 0.1));
    test_printstr(" OK\n");
    
    // Test 5: exp(0) = 1
    complex zero = {0.0, 0.0};
    complex e0 = c_exp(zero);
    test_printstr("  exp0: ");
    TEST_ASSERT(approx_equal(e0.re, 1.0, 1e-6) && approx_equal(e0.im, 0.0, 1e-6));
    test_printstr("OK\n");
    
    // Test 6: exp(i*pi) ≈ -1
    complex ipi = {0.0, 3.14159265358979};
    complex eipi = c_exp(ipi);
    test_printstr("  expi: ");
    test_printint((int)(eipi.re * 1000)); // Should be close to -1000
    TEST_ASSERT(approx_equal(eipi.re, -1.0, 0.01));
    test_printstr(" OK\n");
    
    // Test 7: (a+b)*c = a*c + b*c
    complex c = {2.0, 1.0};
    complex ab = c_add(a, b);
    complex abc1 = c_mul(ab, c);
    complex ac = c_mul(a, c);
    complex bc = c_mul(b, c);
    complex abc2 = c_add(ac, bc);
    test_printstr("  distrib: ");
    TEST_ASSERT(c_equals(abc1, abc2, 1e-10));
    test_printstr("OK\n");
    
    test_printstr("All complex tests passed!\n");
    test_pass();
    return 0;
}
