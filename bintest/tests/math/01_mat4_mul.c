// 4x4 Double Precision Matrix Multiplication Test
// Tests: Double precision floating point matrix operations
#include "test_syscall.h"

typedef double mat4[4][4];

void mat4_mul(mat4 a, mat4 b, mat4 c) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            c[i][j] = 0;
            for (int k = 0; k < 4; k++) {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}

void mat4_identity(mat4 m) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            m[i][j] = (i == j) ? 1.0 : 0.0;
        }
    }
}

void mat4_scale(mat4 m, double s) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            m[i][j] *= s;
        }
    }
}

int mat4_equals(mat4 a, mat4 b, double eps) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            double diff = a[i][j] - b[i][j];
            if (diff < 0) diff = -diff;
            if (diff > eps) return 0;
        }
    }
    return 1;
}

void mat4_copy(mat4 dest, mat4 src) {
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            dest[i][j] = src[i][j];
        }
    }
}

int test_main(void) {
    test_printstr("Testing 4x4 Matrix Multiplication...\n");
    
    // Test 1: Identity multiplication
    mat4 id, a, result;
    mat4_identity(id);
    
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            a[i][j] = (i + 1) * (j + 1);
        }
    }
    
    mat4_mul(id, a, result);
    test_printstr("  identity: ");
    TEST_ASSERT(mat4_equals(result, a, 1e-10));
    test_printstr("OK\n");
    
    // Test 2: Scale matrix
    mat4 scale_a, scale_b, scale_result;
    mat4_identity(scale_a);
    mat4_identity(scale_b);
    mat4_scale(scale_a, 2.0);
    mat4_scale(scale_b, 3.0);
    mat4_mul(scale_a, scale_b, scale_result);
    
    test_printstr("  scale: ");
    mat4 expected;
    mat4_identity(expected);
    mat4_scale(expected, 6.0);
    TEST_ASSERT(mat4_equals(scale_result, expected, 1e-10));
    test_printstr("OK\n");
    
    // Test 3: Known matrix multiplication
    mat4 m1 = {{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 1, 2, 3}, {4, 5, 6, 7}};
    mat4 m2 = {{7, 6, 5, 4}, {3, 2, 1, 9}, {8, 7, 6, 5}, {4, 3, 2, 1}};
    mat4 m3;
    mat4_mul(m1, m2, m3);
    
    // m3[0][0] = 1*7 + 2*3 + 3*8 + 4*4 = 7 + 6 + 24 + 16 = 53
    test_printstr("  mul: ");
    TEST_ASSERT(m3[0][0] > 52.9 && m3[0][0] < 53.1);
    test_printstr("OK\n");
    
    // Test 4: Associativity (A*B)*C == A*(B*C)
    mat4 m4 = {{1, 0, 0, 0}, {0, 2, 0, 0}, {0, 0, 3, 0}, {0, 0, 0, 4}};
    mat4 m5 = {{5, 0, 0, 0}, {0, 6, 0, 0}, {0, 0, 7, 0}, {0, 0, 0, 8}};
    mat4 m6 = {{9, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 2, 0}, {0, 0, 0, 3}};
    
    mat4 ab, abc1, bc, abc2;
    mat4_mul(m4, m5, ab);
    mat4_mul(ab, m6, abc1);
    mat4_mul(m5, m6, bc);
    mat4_mul(m4, bc, abc2);
    
    test_printstr("  assoc: ");
    TEST_ASSERT(mat4_equals(abc1, abc2, 1e-10));
    test_printstr("OK\n");
    
    test_printstr("All matrix tests passed!\n");
    test_pass();
    return 0;
}
