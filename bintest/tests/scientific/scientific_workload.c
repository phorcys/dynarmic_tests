/*
 * Scientific Computing Workload Test
 * Tests mathematical and scientific computations
 */

#include "test_syscall.h"

/* Infinity constant */
#define INF_POS (1.0 / 0.0)

/* Approximate square root using Newton-Raphson */
static double sqrt_nr(double x) {
    if (x <= 0) return 0;
    double guess = x / 2.0;
    for (int i = 0; i < 20; i++) {
        guess = (guess + x / guess) / 2.0;
    }
    return guess;
}

/* Approximate sine using Taylor series */
static double sin_taylor(double x) {
    /* Normalize to [-pi, pi] */
    while (x > 3.14159265) x -= 2.0 * 3.14159265;
    while (x < -3.14159265) x += 2.0 * 3.14159265;
    
    double result = 0.0;
    double term = x;
    double x2 = x * x;
    
    for (int i = 1; i <= 15; i += 2) {
        result += term;
        term *= -x2 / ((i + 1) * (i + 2));
    }
    
    return result;
}

/* Approximate cosine */
static double cos_taylor(double x) {
    return sin_taylor(x + 3.14159265 / 2.0);
}

/* Approximate exponential using Taylor series */
static double exp_taylor(double x) {
    double result = 1.0;
    double term = 1.0;
    
    for (int i = 1; i <= 20; i++) {
        term *= x / i;
        result += term;
    }
    
    return result;
}

/* Natural logarithm using Newton's method */
static double log_newton(double x) {
    if (x <= 0) return -INF_POS;
    
    double y = x;
    for (int i = 0; i < 20; i++) {
        double e = exp_taylor(y);
        y = y - 1.0 + x / e;
    }
    return y;
}

/* Power function */
static double power(double base, double exp) {
    if (exp == 0) return 1.0;
    if (base <= 0) return 0;
    return exp_taylor(exp * log_newton(base));
}

static int test_math_functions(void) {
    test_printstr("Testing math functions...\n");
    
    /* Test sqrt */
    double result = sqrt_nr(4.0);
    TEST_ASSERT(result > 1.99 && result < 2.01);
    
    result = sqrt_nr(100.0);
    TEST_ASSERT(result > 9.99 && result < 10.01);
    
    /* Test sin/cos */
    result = sin_taylor(0.0);
    TEST_ASSERT(result > -0.0001 && result < 0.0001);
    
    result = sin_taylor(1.5708);  /* pi/2 */
    TEST_ASSERT(result > 0.999 && result < 1.001);
    
    result = cos_taylor(0.0);
    TEST_ASSERT(result > 0.999 && result < 1.001);
    
    /* Test exp */
    result = exp_taylor(0.0);
    TEST_ASSERT(result > 0.999 && result < 1.001);
    
    result = exp_taylor(1.0);
    TEST_ASSERT(result > 2.71 && result < 2.72);
    
    test_printstr("  Math functions: PASS\n");
    return 0;
}

/* Matrix operations for scientific computing */
static void mat_mult_3x3(double a[3][3], double b[3][3], double c[3][3]) {
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            c[i][j] = 0;
            for (int k = 0; k < 3; k++) {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}

static double mat_det_3x3(double m[3][3]) {
    return m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1])
         - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0])
         + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]);
}

static int test_matrix_ops(void) {
    test_printstr("Testing matrix operations...\n");
    
    double a[3][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
    double b[3][3] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};  /* Identity */
    double c[3][3];
    
    /* Multiply by identity should give same matrix */
    mat_mult_3x3(a, b, c);
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            TEST_ASSERT(c[i][j] == a[i][j]);
        }
    }
    
    /* Test determinant of identity */
    double det = mat_det_3x3(b);
    TEST_ASSERT(det == 1.0);
    
    /* Test determinant of singular matrix (det = 0) */
    double singular[3][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
    det = mat_det_3x3(singular);
    TEST_ASSERT(det > -0.001 && det < 0.001);
    
    test_printstr("  Matrix ops: PASS\n");
    return 0;
}

/* Simple numerical integration (trapezoidal rule) */
static double integrate(double (*f)(double), double a, double b, int n) {
    double h = (b - a) / n;
    double sum = (f(a) + f(b)) / 2.0;
    
    for (int i = 1; i < n; i++) {
        sum += f(a + i * h);
    }
    
    return sum * h;
}

static double square_func(double x) { return x * x; }
static double linear_func(double x) { return x; }

static int test_integration(void) {
    test_printstr("Testing numerical integration...\n");
    
    /* Integral of x^2 from 0 to 1 = 1/3 */
    double result = integrate(square_func, 0.0, 1.0, 1000);
    TEST_ASSERT(result > 0.33 && result < 0.34);
    
    /* Integral of x from 0 to 1 = 1/2 */
    result = integrate(linear_func, 0.0, 1.0, 1000);
    TEST_ASSERT(result > 0.49 && result < 0.51);
    
    test_printstr("  Integration: PASS\n");
    return 0;
}

/* Simple statistics functions */
static double mean(double *data, int n) {
    double sum = 0;
    for (int i = 0; i < n; i++) sum += data[i];
    return sum / n;
}

static double variance(double *data, int n) {
    double m = mean(data, n);
    double sum = 0;
    for (int i = 0; i < n; i++) {
        double d = data[i] - m;
        sum += d * d;
    }
    return sum / n;
}

static double stddev(double *data, int n) {
    return sqrt_nr(variance(data, n));
}

static int test_statistics(void) {
    test_printstr("Testing statistics...\n");
    
    double data[] = {1.0, 2.0, 3.0, 4.0, 5.0};
    int n = 5;
    
    double m = mean(data, n);
    TEST_ASSERT(m > 2.99 && m < 3.01);
    
    double v = variance(data, n);
    TEST_ASSERT(v > 1.99 && v < 2.01);  /* Variance = 2 */
    
    double s = stddev(data, n);
    TEST_ASSERT(s > 1.41 && s < 1.42);  /* StdDev = sqrt(2) */
    
    test_printstr("  Statistics: PASS\n");
    return 0;
}

/* Simple FFT-like computation */
static int test_dft(void) {
    test_printstr("Testing DFT-like computation...\n");
    
    /* Simple DFT for 8-point signal */
    int N = 8;
    double signal[] = {1.0, 0.5, -0.5, -1.0, -0.5, 0.5, 1.0, 0.5};
    double real[8], imag[8];
    
    /* DFT */
    for (int k = 0; k < N; k++) {
        real[k] = 0;
        imag[k] = 0;
        for (int n = 0; n < N; n++) {
            double angle = -2.0 * 3.14159265 * k * n / N;
            real[k] += signal[n] * cos_taylor(angle);
            imag[k] += signal[n] * sin_taylor(angle);
        }
    }
    
    /* DC component (k=0) should be sum of all values */
    TEST_ASSERT(real[0] > 1.4 && real[0] < 1.6);  /* Sum = 1.5 */
    TEST_ASSERT(imag[0] > -0.01 && imag[0] < 0.01);
    
    test_printstr("  DFT: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Scientific Computing Tests ===\n");
    
    test_math_functions();
    test_matrix_ops();
    test_integration();
    test_statistics();
    test_dft();
    
    test_printstr("=== All scientific tests passed ===\n");
    test_pass();
    return 0;
}
