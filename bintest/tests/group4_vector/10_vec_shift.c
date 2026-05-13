// Test vector shift operations
#include "test_syscall.h"

void vec_lsl(int* a, int shift, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] << shift;
    }
}

void vec_lsr(unsigned int* a, int shift, unsigned int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] >> shift;
    }
}

void vec_asr(int* a, int shift, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] >> shift;
    }
}

void vec_ror(unsigned int* a, int shift, unsigned int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (a[i] >> shift) | (a[i] << (32 - shift));
    }
}

void vec_lsl_var(int* a, int* shift, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] << (shift[i] & 31);
    }
}

int test_main(void) {
    test_printstr("Testing vector shifts...\n");
    
    // Test 1: Left shift
    int a1[] = {1, 2, 3, 4};
    int c1[4];
    vec_lsl(a1, 4, c1, 4);
    test_printstr("  lsl: ");
    TEST_ASSERT(c1[0] == 16);
    TEST_ASSERT(c1[1] == 32);
    TEST_ASSERT(c1[2] == 48);
    TEST_ASSERT(c1[3] == 64);
    test_printstr("OK\n");
    
    // Test 2: Logical right shift
    unsigned int a2[] = {0x1000, 0x2000, 0x4000, 0x8000};
    unsigned int c2[4];
    vec_lsr(a2, 4, c2, 4);
    test_printstr("  lsr: ");
    TEST_ASSERT(c2[0] == 0x100);
    TEST_ASSERT(c2[1] == 0x200);
    TEST_ASSERT(c2[2] == 0x400);
    TEST_ASSERT(c2[3] == 0x800);
    test_printstr("OK\n");
    
    // Test 3: Arithmetic right shift (positive)
    int a3[] = {1000, 2000, 4000, 8000};
    int c3[4];
    vec_asr(a3, 2, c3, 4);
    test_printstr("  asr_pos: ");
    TEST_ASSERT(c3[0] == 250);
    TEST_ASSERT(c3[1] == 500);
    TEST_ASSERT(c3[2] == 1000);
    TEST_ASSERT(c3[3] == 2000);
    test_printstr("OK\n");
    
    // Test 4: Arithmetic right shift (negative)
    int a4[] = {-1000, -2000, -4000, -8000};
    int c4[4];
    vec_asr(a4, 2, c4, 4);
    test_printstr("  asr_neg: ");
    TEST_ASSERT(c4[0] == -250);
    TEST_ASSERT(c4[1] == -500);
    TEST_ASSERT(c4[2] == -1000);
    TEST_ASSERT(c4[3] == -2000);
    test_printstr("OK\n");
    
    // Test 5: Rotate right
    unsigned int a5[] = {0x80000001, 0x40000002, 0x20000004, 0x10000008};
    unsigned int c5[4];
    vec_ror(a5, 4, c5, 4);
    test_printstr("  ror: ");
    TEST_ASSERT(c5[0] == 0x18000000);
    TEST_ASSERT(c5[1] == 0x24000000);
    TEST_ASSERT(c5[2] == 0x42000000);
    TEST_ASSERT(c5[3] == 0x81000000);
    test_printstr("OK\n");
    
    // Test 6: Variable shift
    int a6[] = {1, 1, 1, 1};
    int s6[] = {0, 1, 2, 3};
    int c6[4];
    vec_lsl_var(a6, s6, c6, 4);
    test_printstr("  lsl_var: ");
    TEST_ASSERT(c6[0] == 1);
    TEST_ASSERT(c6[1] == 2);
    TEST_ASSERT(c6[2] == 4);
    TEST_ASSERT(c6[3] == 8);
    test_printstr("OK\n");
    
    test_printstr("All vector shift tests passed!\n");
    test_pass();
    return 0;
}
