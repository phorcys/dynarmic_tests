// Test SIMD-style parallel operations
#include "test_syscall.h"

// Process 4 integers in parallel (SIMD-like)
void simd_add4(int* a, int* b, int* c) {
    c[0] = a[0] + b[0];
    c[1] = a[1] + b[1];
    c[2] = a[2] + b[2];
    c[3] = a[3] + b[3];
}

void simd_mul4(int* a, int* b, int* c) {
    c[0] = a[0] * b[0];
    c[1] = a[1] * b[1];
    c[2] = a[2] * b[2];
    c[3] = a[3] * b[3];
}

void simd_min4(int* a, int* b, int* c) {
    c[0] = (a[0] < b[0]) ? a[0] : b[0];
    c[1] = (a[1] < b[1]) ? a[1] : b[1];
    c[2] = (a[2] < b[2]) ? a[2] : b[2];
    c[3] = (a[3] < b[3]) ? a[3] : b[3];
}

void simd_max4(int* a, int* b, int* c) {
    c[0] = (a[0] > b[0]) ? a[0] : b[0];
    c[1] = (a[1] > b[1]) ? a[1] : b[1];
    c[2] = (a[2] > b[2]) ? a[2] : b[2];
    c[3] = (a[3] > b[3]) ? a[3] : b[3];
}

void simd_sum4(int* a, int* result) {
    *result = a[0] + a[1] + a[2] + a[3];
}

void simd_dp4(int* a, int* b, int* result) {
    *result = a[0]*b[0] + a[1]*b[1] + a[2]*b[2] + a[3]*b[3];
}

int test_main(void) {
    test_printstr("Testing SIMD-style operations...\n");
    
    int a[] = {1, 2, 3, 4};
    int b[] = {4, 3, 2, 1};
    int c[4];
    
    // Test 1: Parallel add
    simd_add4(a, b, c);
    test_printstr("  add4: ");
    TEST_ASSERT(c[0] == 5 && c[1] == 5 && c[2] == 5 && c[3] == 5);
    test_printstr("OK\n");
    
    // Test 2: Parallel mul
    simd_mul4(a, b, c);
    test_printstr("  mul4: ");
    TEST_ASSERT(c[0] == 4 && c[1] == 6 && c[2] == 6 && c[3] == 4);
    test_printstr("OK\n");
    
    // Test 3: Parallel min
    simd_min4(a, b, c);
    test_printstr("  min4: ");
    TEST_ASSERT(c[0] == 1 && c[1] == 2 && c[2] == 2 && c[3] == 1);
    test_printstr("OK\n");
    
    // Test 4: Parallel max
    simd_max4(a, b, c);
    test_printstr("  max4: ");
    TEST_ASSERT(c[0] == 4 && c[1] == 3 && c[2] == 3 && c[3] == 4);
    test_printstr("OK\n");
    
    // Test 5: Horizontal sum
    int sum;
    simd_sum4(a, &sum);
    test_printstr("  sum4: ");
    test_printint(sum);
    TEST_ASSERT(sum == 10);
    test_printstr(" OK\n");
    
    // Test 6: Dot product
    int dp;
    simd_dp4(a, b, &dp);
    test_printstr("  dp4: ");
    test_printint(dp);
    TEST_ASSERT(dp == 20);  // 1*4 + 2*3 + 3*2 + 4*1 = 20
    test_printstr(" OK\n");
    
    // Test 7: Multiple iterations
    int data[4] = {10, 20, 30, 40};
    int inc[4] = {1, 1, 1, 1};
    for (int i = 0; i < 5; i++) {
        simd_add4(data, inc, data);
    }
    test_printstr("  iter: ");
    TEST_ASSERT(data[0] == 15 && data[1] == 25 && data[2] == 35 && data[3] == 45);
    test_printstr("OK\n");
    
    test_printstr("All SIMD-style tests passed!\n");
    test_pass();
    return 0;
}
