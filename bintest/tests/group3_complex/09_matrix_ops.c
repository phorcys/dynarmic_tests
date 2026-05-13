// Test matrix operations (simplified)
#include "test_syscall.h"

static int mat_a[3][3];
static int mat_b[3][3];
static int mat_c[3][3];

void mat_init(int m[3][3], int val) {
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            m[i][j] = val + i * 3 + j;
        }
    }
}

int mat_trace(int m[3][3]) {
    int trace = 0;
    for (int i = 0; i < 3; i++) {
        trace += m[i][i];
    }
    return trace;
}

int mat_sum(int m[3][3]) {
    int sum = 0;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            sum += m[i][j];
        }
    }
    return sum;
}

int test_main(void) {
    test_printstr("Testing matrix operations...\n");
    
    // Test 1: Matrix initialization
    mat_init(mat_a, 0);
    test_printstr("  mat_a[0][0]: ");
    test_printint(mat_a[0][0]);
    test_printstr(", [2][2]: ");
    test_printint(mat_a[2][2]);
    TEST_ASSERT(mat_a[0][0] == 0 && mat_a[2][2] == 8);
    
    // Test 2: Matrix trace
    mat_init(mat_a, 1);
    int trace = mat_trace(mat_a);
    test_printstr("\n  trace: ");
    test_printint(trace);
    // 1 + 5 + 9 = 15
    TEST_ASSERT(trace == 15);
    
    // Test 3: Matrix sum
    int sum = mat_sum(mat_a);
    test_printstr("\n  sum: ");
    test_printint(sum);
    // Sum of 1..9 = 45
    TEST_ASSERT(sum == 45);
    
    test_printstr("\nAll matrix tests passed!\n");
    test_pass();
    return 0;
}
