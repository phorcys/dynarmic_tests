// Test vector logical operations
#include "test_syscall.h"

void vec_and(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] & b[i];
    }
}

void vec_or(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] | b[i];
    }
}

void vec_xor(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] ^ b[i];
    }
}

void vec_not(int* a, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = ~a[i];
    }
}

void vec_and_not(int* a, int* b, int* c, int n) {
    // c = a & ~b (bit clear)
    for (int i = 0; i < n; i++) {
        c[i] = a[i] & ~b[i];
    }
}

int test_main(void) {
    test_printstr("Testing vector logic...\n");
    
    // Test 1: AND
    int a1[] = {0xFF, 0xFF00, 0x00FF00, 0xFF0000};
    int b1[] = {0x0F, 0x00FF, 0x00FF00, 0x00FF00};
    int c1[4];
    vec_and(a1, b1, c1, 4);
    test_printstr("  and: ");
    TEST_ASSERT(c1[0] == 0x0F);
    TEST_ASSERT(c1[1] == 0x0000);
    TEST_ASSERT(c1[2] == 0x00FF00);
    TEST_ASSERT(c1[3] == 0x000000);
    test_printstr("OK\n");
    
    // Test 2: OR
    int a2[] = {0xF0, 0x0F, 0xF00, 0x00F};
    int b2[] = {0x0F, 0xF0, 0x00F, 0xF00};
    int c2[4];
    vec_or(a2, b2, c2, 4);
    test_printstr("  or: ");
    TEST_ASSERT(c2[0] == 0xFF);
    TEST_ASSERT(c2[1] == 0xFF);
    TEST_ASSERT(c2[2] == 0xF0F);
    TEST_ASSERT(c2[3] == 0xF0F);
    test_printstr("OK\n");
    
    // Test 3: XOR
    int a3[] = {0xAA, 0x55, 0xCC, 0x33};
    int b3[] = {0x55, 0xAA, 0x33, 0xCC};
    int c3[4];
    vec_xor(a3, b3, c3, 4);
    test_printstr("  xor: ");
    TEST_ASSERT(c3[0] == 0xFF);
    TEST_ASSERT(c3[1] == 0xFF);
    TEST_ASSERT(c3[2] == 0xFF);
    TEST_ASSERT(c3[3] == 0xFF);
    test_printstr("OK\n");
    
    // Test 4: NOT
    int a4[] = {0, -1, 0xAAAAAAAA, 0x55555555};
    int c4[4];
    vec_not(a4, c4, 4);
    test_printstr("  not: ");
    TEST_ASSERT(c4[0] == -1);
    TEST_ASSERT(c4[1] == 0);
    TEST_ASSERT(c4[2] == 0x55555555);
    TEST_ASSERT(c4[3] == 0xAAAAAAAA);
    test_printstr("OK\n");
    
    // Test 5: AND-NOT (bit clear)
    int a5[] = {0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF};
    int b5[] = {0x00FF, 0xFF00, 0x0F0F, 0xF0F0};
    int c5[4];
    vec_and_not(a5, b5, c5, 4);
    test_printstr("  bic: ");
    TEST_ASSERT(c5[0] == 0xFF00);
    TEST_ASSERT(c5[1] == 0x00FF);
    TEST_ASSERT(c5[2] == 0xF0F0);
    TEST_ASSERT(c5[3] == 0x0F0F);
    test_printstr("OK\n");
    
    test_printstr("All vector logic tests passed!\n");
    test_pass();
    return 0;
}
