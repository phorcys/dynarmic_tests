// LU Decomposition Test
// Tests: Solving linear systems using LU decomposition
#include "test_syscall.h"

#define N 3

// LU decomposition with partial pivoting
int lu_decompose(double a[N][N], int perm[N]) {
    for (int i = 0; i < N; i++) perm[i] = i;
    
    for (int k = 0; k < N - 1; k++) {
        // Find pivot
        int max_row = k;
        double max_val = a[k][k];
        if (max_val < 0) max_val = -max_val;
        
        for (int i = k + 1; i < N; i++) {
            double val = a[i][k];
            if (val < 0) val = -val;
            if (val > max_val) {
                max_val = val;
                max_row = i;
            }
        }
        
        // Swap rows
        if (max_row != k) {
            for (int j = 0; j < N; j++) {
                double temp = a[k][j];
                a[k][j] = a[max_row][j];
                a[max_row][j] = temp;
            }
            int temp = perm[k];
            perm[k] = perm[max_row];
            perm[max_row] = temp;
        }
        
        // Check for singularity
        if (max_val < 1e-15) return 0;
        
        // Elimination
        for (int i = k + 1; i < N; i++) {
            a[i][k] /= a[k][k];
            for (int j = k + 1; j < N; j++) {
                a[i][j] -= a[i][k] * a[k][j];
            }
        }
    }
    
    return 1;
}

// Solve LUx = Pb
void lu_solve(double lu[N][N], int perm[N], double b[N], double x[N]) {
    double y[N];
    
    // Forward substitution: Ly = Pb
    for (int i = 0; i < N; i++) {
        double sum = b[perm[i]];
        for (int j = 0; j < i; j++) {
            sum -= lu[i][j] * y[j];
        }
        y[i] = sum;
    }
    
    // Back substitution: Ux = y
    for (int i = N - 1; i >= 0; i--) {
        double sum = y[i];
        for (int j = i + 1; j < N; j++) {
            sum -= lu[i][j] * x[j];
        }
        x[i] = sum / lu[i][i];
    }
}

int approx_equal(double a, double b, double eps) {
    double diff = a - b;
    if (diff < 0) diff = -diff;
    return diff < eps;
}

int test_main(void) {
    test_printstr("Testing LU Decomposition...\n");
    
    // Test 1: Simple 3x3 system
    // 2x + y - z = 8
    // -3x - y + 2z = -11
    // -2x + y + 2z = -3
    // Solution: x=2, y=3, z=-1
    
    double a1[N][N] = {
        {2.0, 1.0, -1.0},
        {-3.0, -1.0, 2.0},
        {-2.0, 1.0, 2.0}
    };
    double b1[N] = {8.0, -11.0, -3.0};
    int perm1[N];
    
    test_printstr("  decomp: ");
    int success = lu_decompose(a1, perm1);
    TEST_ASSERT(success);
    test_printstr("OK\n");
    
    double x1[N];
    lu_solve(a1, perm1, b1, x1);
    
    test_printstr("  solve: ");
    test_printint((int)(x1[0] + 0.5));
    test_printstr(",");
    test_printint((int)(x1[1] + 0.5));
    test_printstr(",");
    test_printint((int)(x1[2] + 0.5));
    test_printstr(" ");
    TEST_ASSERT(approx_equal(x1[0], 2.0, 1e-6));
    TEST_ASSERT(approx_equal(x1[1], 3.0, 1e-6));
    TEST_ASSERT(approx_equal(x1[2], -1.0, 1e-6));
    test_printstr("OK\n");
    
    // Test 2: Diagonal system
    double a2[N][N] = {
        {1.0, 0.0, 0.0},
        {0.0, 2.0, 0.0},
        {0.0, 0.0, 3.0}
    };
    double b2[N] = {1.0, 2.0, 3.0};
    int perm2[N];
    
    lu_decompose(a2, perm2);
    double x2[N];
    lu_solve(a2, perm2, b2, x2);
    
    test_printstr("  diagonal: ");
    TEST_ASSERT(approx_equal(x2[0], 1.0, 1e-6));
    TEST_ASSERT(approx_equal(x2[1], 1.0, 1e-6));
    TEST_ASSERT(approx_equal(x2[2], 1.0, 1e-6));
    test_printstr("OK\n");
    
    // Test 3: Identity system
    double a3[N][N] = {
        {1.0, 0.0, 0.0},
        {0.0, 1.0, 0.0},
        {0.0, 0.0, 1.0}
    };
    double b3[N] = {5.0, 6.0, 7.0};
    int perm3[N];
    
    lu_decompose(a3, perm3);
    double x3[N];
    lu_solve(a3, perm3, b3, x3);
    
    test_printstr("  identity: ");
    TEST_ASSERT(approx_equal(x3[0], 5.0, 1e-6));
    TEST_ASSERT(approx_equal(x3[1], 6.0, 1e-6));
    TEST_ASSERT(approx_equal(x3[2], 7.0, 1e-6));
    test_printstr("OK\n");
    
    test_printstr("All LU decomposition tests passed!\n");
    test_pass();
    return 0;
}
