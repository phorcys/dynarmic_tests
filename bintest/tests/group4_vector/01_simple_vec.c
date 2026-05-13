// Test simple SIMD-like operations using arrays
#include "test_syscall.h"

void vec_add(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

void vec_sub(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] - b[i];
    }
}

void vec_mul(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] * b[i];
    }
}

int vec_dot(int* a, int* b, int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += a[i] * b[i];
    }
    return sum;
}

int test_main(void) {
    test_printstr("Testing vector operations...\n");
    
    int a[] = {1, 2, 3, 4};
    int b[] = {5, 6, 7, 8};
    int c[4];
    
    // Test 1: Vector add
    vec_add(a, b, c, 4);
    test_printstr("  add: ");
    test_printint(c[0]);
    test_printstr(" ");
    test_printint(c[3]);
    TEST_ASSERT(c[0] == 6 && c[3] == 12);
    
    // Test 2: Vector sub
    vec_sub(b, a, c, 4);
    test_printstr("\n  sub: ");
    test_printint(c[0]);
    test_printstr(" ");
    test_printint(c[3]);
    TEST_ASSERT(c[0] == 4 && c[3] == 4);
    
    // Test 3: Vector mul
    vec_mul(a, b, c, 4);
    test_printstr("\n  mul: ");
    test_printint(c[0]);
    test_printstr(" ");
    test_printint(c[3]);
    TEST_ASSERT(c[0] == 5 && c[3] == 32);
    
    // Test 4: Dot product
    int dot = vec_dot(a, b, 4);
    test_printstr("\n  dot: ");
    test_printint(dot);
    // 1*5 + 2*6 + 3*7 + 4*8 = 5+12+21+32 = 70
    TEST_ASSERT(dot == 70);
    
    test_printstr("\nAll vector tests passed!\n");
    test_pass();
    return 0;
}
