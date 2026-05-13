// Test vector min/max and abs operations
#include "test_syscall.h"

void vec_min_int(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (a[i] < b[i]) ? a[i] : b[i];
    }
}

void vec_max_int(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (a[i] > b[i]) ? a[i] : b[i];
    }
}

void vec_abs_int(int* a, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (a[i] < 0) ? -a[i] : a[i];
    }
}

void vec_neg_int(int* a, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = -a[i];
    }
}

void vec_clamp_int(int* a, int min, int max, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i];
        if (c[i] < min) c[i] = min;
        if (c[i] > max) c[i] = max;
    }
}

int test_main(void) {
    test_printstr("Testing vector min/max/abs...\n");
    
    // Test 1: Min
    int a1[] = {10, 20, 30, 40};
    int b1[] = {40, 30, 20, 10};
    int c1[4];
    vec_min_int(a1, b1, c1, 4);
    test_printstr("  min: ");
    TEST_ASSERT(c1[0] == 10);
    TEST_ASSERT(c1[1] == 20);
    TEST_ASSERT(c1[2] == 20);
    TEST_ASSERT(c1[3] == 10);
    test_printstr("OK\n");
    
    // Test 2: Max
    int c2[4];
    vec_max_int(a1, b1, c2, 4);
    test_printstr("  max: ");
    TEST_ASSERT(c2[0] == 40);
    TEST_ASSERT(c2[1] == 30);
    TEST_ASSERT(c2[2] == 30);
    TEST_ASSERT(c2[3] == 40);
    test_printstr("OK\n");
    
    // Test 3: Abs (positive values)
    int a3[] = {10, 20, 30, 40};
    int c3[4];
    vec_abs_int(a3, c3, 4);
    test_printstr("  abs_pos: ");
    TEST_ASSERT(c3[0] == 10);
    TEST_ASSERT(c3[1] == 20);
    TEST_ASSERT(c3[2] == 30);
    TEST_ASSERT(c3[3] == 40);
    test_printstr("OK\n");
    
    // Test 4: Abs (negative values)
    int a4[] = {-10, -20, -30, -40};
    int c4[4];
    vec_abs_int(a4, c4, 4);
    test_printstr("  abs_neg: ");
    TEST_ASSERT(c4[0] == 10);
    TEST_ASSERT(c4[1] == 20);
    TEST_ASSERT(c4[2] == 30);
    TEST_ASSERT(c4[3] == 40);
    test_printstr("OK\n");
    
    // Test 5: Abs (mixed)
    int a5[] = {-100, 50, -25, 75};
    int c5[4];
    vec_abs_int(a5, c5, 4);
    test_printstr("  abs_mix: ");
    TEST_ASSERT(c5[0] == 100);
    TEST_ASSERT(c5[1] == 50);
    TEST_ASSERT(c5[2] == 25);
    TEST_ASSERT(c5[3] == 75);
    test_printstr("OK\n");
    
    // Test 6: Negate
    int a6[] = {10, -20, 30, -40};
    int c6[4];
    vec_neg_int(a6, c6, 4);
    test_printstr("  neg: ");
    TEST_ASSERT(c6[0] == -10);
    TEST_ASSERT(c6[1] == 20);
    TEST_ASSERT(c6[2] == -30);
    TEST_ASSERT(c6[3] == 40);
    test_printstr("OK\n");
    
    // Test 7: Clamp
    int a7[] = {10, 50, 100, 150};
    int c7[4];
    vec_clamp_int(a7, 20, 100, c7, 4);
    test_printstr("  clamp: ");
    TEST_ASSERT(c7[0] == 20);   // 10 < 20, clamped to 20
    TEST_ASSERT(c7[1] == 50);   // 20 <= 50 <= 100, unchanged
    TEST_ASSERT(c7[2] == 100);  // 100 == max, unchanged
    TEST_ASSERT(c7[3] == 100);  // 150 > 100, clamped to 100
    test_printstr("OK\n");
    
    test_printstr("All vector min/max/abs tests passed!\n");
    test_pass();
    return 0;
}
