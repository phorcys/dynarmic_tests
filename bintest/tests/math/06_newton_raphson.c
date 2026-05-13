// Newton-Raphson Root Finding Test
// Tests: Newton-Raphson method for finding roots
#include "test_syscall.h"

double abs_d(double x) {
    return x < 0 ? -x : x;
}

// f(x) = x^2 - 2 (root is sqrt(2))
double f_sqrt2(double x) {
    return x * x - 2.0;
}

// f'(x) = 2x
double df_sqrt2(double x) {
    return 2.0 * x;
}

// f(x) = x^3 - x - 2
double f_cubic(double x) {
    return x * x * x - x - 2.0;
}

// f'(x) = 3x^2 - 1
double df_cubic(double x) {
    return 3.0 * x * x - 1.0;
}

double newton_raphson(double (*f)(double), double (*df)(double), double x0, int max_iter, double tol) {
    double x = x0;
    
    for (int i = 0; i < max_iter; i++) {
        double fx = f(x);
        double dfx = df(x);
        
        if (abs_d(dfx) < 1e-15) break;
        
        double x_new = x - fx / dfx;
        
        if (abs_d(x_new - x) < tol) {
            return x_new;
        }
        
        x = x_new;
    }
    
    return x;
}

int approx_equal(double a, double b, double eps) {
    return abs_d(a - b) < eps;
}

int test_main(void) {
    test_printstr("Testing Newton-Raphson...\n");
    double root;
    
    // Test 1: Find sqrt(2)
    root = newton_raphson(f_sqrt2, df_sqrt2, 1.5, 100, 1e-10);
    test_printstr("  sqrt2: ");
    test_printint((int)(root * 10000));
    test_printstr(" ");
    // sqrt(2) ≈ 1.414213562
    TEST_ASSERT(approx_equal(root, 1.414213562, 1e-6));
    test_printstr("OK\n");
    
    // Test 2: Find root of x^3 - x - 2
    // Root is approximately 1.521
    root = newton_raphson(f_cubic, df_cubic, 2.0, 100, 1e-10);
    test_printstr("  cubic: ");
    test_printint((int)(root * 1000));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(root, 1.521, 0.01));
    test_printstr("OK\n");
    
    // Test 3: Different starting point
    root = newton_raphson(f_sqrt2, df_sqrt2, 2.0, 100, 1e-10);
    test_printstr("  start2: ");
    test_printint((int)(root * 10000));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(root, 1.414213562, 1e-6));
    test_printstr("OK\n");
    
    // Test 4: Verify the root (f(x) ≈ 0)
    root = newton_raphson(f_sqrt2, df_sqrt2, 1.0, 100, 1e-10);
    double f_val = f_sqrt2(root);
    test_printstr("  verify: ");
    test_printint((int)(abs_d(f_val) * 1000000));
    test_printstr(" ");
    TEST_ASSERT(abs_d(f_val) < 1e-8);
    test_printstr("OK\n");
    
    // Test 5: Convergence in few iterations
    root = newton_raphson(f_sqrt2, df_sqrt2, 1.5, 10, 1e-10);
    test_printstr("  fast: ");
    TEST_ASSERT(approx_equal(root, 1.414213562, 1e-6));
    test_printstr("OK\n");
    
    test_printstr("All Newton-Raphson tests passed!\n");
    test_pass();
    return 0;
}
