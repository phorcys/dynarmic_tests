// Test vector multiplication operations
#include "test_syscall.h"

void vec_mul_int(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] * b[i];
    }
}

void vec_div_int(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] / b[i];
    }
}

void vec_mod_int(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] % b[i];
    }
}

void vec_mla_int(int* a, int* b, int* c, int n) {
    // c = a * b + c (multiply-accumulate)
    for (int i = 0; i < n; i++) {
        c[i] = a[i] * b[i] + c[i];
    }
}

int test_main(void) {
    test_printstr("Testing vector multiplication...\n");
    
    // Test 1: Integer multiplication
    int a1[] = {1, 2, 3, 4, 5, 6, 7, 8};
    int b1[] = {2, 3, 4, 5, 6, 7, 8, 9};
    int c1[8];
    vec_mul_int(a1, b1, c1, 8);
    test_printstr("  mul: ");
    TEST_ASSERT(c1[0] == 2);
    TEST_ASSERT(c1[1] == 6);
    TEST_ASSERT(c1[2] == 12);
    TEST_ASSERT(c1[3] == 20);
    TEST_ASSERT(c1[4] == 30);
    TEST_ASSERT(c1[5] == 42);
    TEST_ASSERT(c1[6] == 56);
    TEST_ASSERT(c1[7] == 72);
    test_printstr("OK\n");
    
    // Test 2: Integer division
    int a2[] = {100, 200, 300, 400, 500};
    int b2[] = {5, 4, 3, 2, 1};
    int c2[5];
    vec_div_int(a2, b2, c2, 5);
    test_printstr("  div: ");
    TEST_ASSERT(c2[0] == 20);
    TEST_ASSERT(c2[1] == 50);
    TEST_ASSERT(c2[2] == 100);
    TEST_ASSERT(c2[3] == 200);
    TEST_ASSERT(c2[4] == 500);
    test_printstr("OK\n");
    
    // Test 3: Modulo
    int a3[] = {17, 25, 33, 41, 49};
    int b3[] = {5, 5, 5, 5, 5};
    int c3[5];
    vec_mod_int(a3, b3, c3, 5);
    test_printstr("  mod: ");
    for (int i = 0; i < 5; i++) {
        TEST_ASSERT(c3[i] == a3[i] % 5);
    }
    test_printstr("OK\n");
    
    // Test 4: Multiply-accumulate
    int a4[] = {1, 2, 3, 4};
    int b4[] = {2, 3, 4, 5};
    int c4[] = {10, 20, 30, 40};
    vec_mla_int(a4, b4, c4, 4);
    test_printstr("  mla: ");
    TEST_ASSERT(c4[0] == 12);  // 1*2 + 10
    TEST_ASSERT(c4[1] == 26);  // 2*3 + 20
    TEST_ASSERT(c4[2] == 42);  // 3*4 + 30
    TEST_ASSERT(c4[3] == 60);  // 4*5 + 40
    test_printstr("OK\n");
    
    test_printstr("All vector multiplication tests passed!\n");
    test_pass();
    return 0;
}
