// Euler Method ODE Solver Test
// Tests: Numerical ODE solution using Euler method
#include "test_syscall.h"

// Solve dy/dx = f(x, y) with initial condition y(x0) = y0
// Using Euler's method: y_{n+1} = y_n + h * f(x_n, y_n)

double abs_d(double x) {
    return x < 0 ? -x : x;
}

// Example 1: dy/dx = x + y, y(0) = 1
// Exact solution: y = 2e^x - x - 1
double f1(double x, double y) {
    return x + y;
}

// Example 2: dy/dx = -y, y(0) = 1
// Exact solution: y = e^{-x}
double f2(double x, double y) {
    (void)x;
    return -y;
}

// Example 3: dy/dx = x^2, y(0) = 0
// Exact solution: y = x^3/3
double f3(double x, double y) {
    (void)y;
    return x * x;
}

double euler(double (*f)(double, double), double x0, double y0, double x_target, int steps) {
    double h = (x_target - x0) / steps;
    double x = x0;
    double y = y0;
    
    for (int i = 0; i < steps; i++) {
        y = y + h * f(x, y);
        x = x + h;
    }
    
    return y;
}

int approx_equal(double a, double b, double eps) {
    return abs_d(a - b) < eps;
}

int test_main(void) {
    test_printstr("Testing Euler Method...\n");
    double result;
    
    // Test 1: dy/dx = x + y, y(0) = 1, find y(0.5)
    // Exact: y(0.5) = 2e^0.5 - 0.5 - 1 ≈ 1.797
    result = euler(f1, 0.0, 1.0, 0.5, 100);
    test_printstr("  f1: ");
    test_printint((int)(result * 100));
    test_printstr(" ");
    // Euler method should give reasonable approximation
    TEST_ASSERT(result > 1.5 && result < 2.2);
    test_printstr("OK\n");
    
    // Test 2: dy/dx = -y, y(0) = 1, find y(1)
    // Exact: y(1) = e^{-1} ≈ 0.368
    result = euler(f2, 0.0, 1.0, 1.0, 100);
    test_printstr("  f2: ");
    test_printint((int)(result * 100));
    test_printstr(" ");
    TEST_ASSERT(result > 0.3 && result < 0.5);
    test_printstr("OK\n");
    
    // Test 3: dy/dx = x^2, y(0) = 0, find y(1)
    // Exact: y(1) = 1/3 ≈ 0.333
    result = euler(f3, 0.0, 0.0, 1.0, 100);
    test_printstr("  f3: ");
    test_printint((int)(result * 100));
    test_printstr(" ");
    TEST_ASSERT(result > 0.30 && result < 0.40);
    test_printstr("OK\n");
    
    // Test 4: Convergence with more steps
    double r100 = euler(f2, 0.0, 1.0, 1.0, 100);
    double r1000 = euler(f2, 0.0, 1.0, 1.0, 1000);
    double exact = 0.36787944117144233;  // e^{-1}
    
    test_printstr("  conv: ");
    double err100 = abs_d(r100 - exact);
    double err1000 = abs_d(r1000 - exact);
    // More steps should give smaller error
    TEST_ASSERT(err1000 < err100);
    test_printstr("OK\n");
    
    // Test 5: Small step
    result = euler(f2, 0.0, 1.0, 0.1, 10);
    // y(0.1) ≈ e^{-0.1} ≈ 0.905
    test_printstr("  small: ");
    test_printint((int)(result * 100));
    test_printstr(" ");
    TEST_ASSERT(result > 0.88 && result < 0.95);
    test_printstr("OK\n");
    
    test_printstr("All Euler method tests passed!\n");
    test_pass();
    return 0;
}
