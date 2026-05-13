// Test simple array-based matrix operations
#include "test_syscall.h"

void mat_vec_mul(int m[3][3], int v[3], int r[3]) {
    for (int i = 0; i < 3; i++) {
        r[i] = 0;
        for (int j = 0; j < 3; j++) {
            r[i] += m[i][j] * v[j];
        }
    }
}

int test_main(void) {
    test_printstr("Testing matrix-vector multiply...\n");
    
    int m[3][3] = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9}
    };
    int v[3] = {1, 2, 3};
    int r[3];
    
    mat_vec_mul(m, v, r);
    
    test_printstr("  result: ");
    test_printint(r[0]);
    test_printstr(" ");
    test_printint(r[1]);
    test_printstr(" ");
    test_printint(r[2]);
    
    // r[0] = 1*1 + 2*2 + 3*3 = 1+4+9 = 14
    // r[1] = 4*1 + 5*2 + 6*3 = 4+10+18 = 32
    // r[2] = 7*1 + 8*2 + 9*3 = 7+16+27 = 50
    TEST_ASSERT(r[0] == 14 && r[1] == 32 && r[2] == 50);
    
    test_printstr("\nAll matrix-vector tests passed!\n");
    test_pass();
    return 0;
}
