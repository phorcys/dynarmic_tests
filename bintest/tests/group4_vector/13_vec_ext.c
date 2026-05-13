// Test vector extend operations
#include "test_syscall.h"

void vec_sxt8(signed char* a, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (int)a[i];  // sign-extend 8-bit to 32-bit
    }
}

void vec_uxt8(unsigned char* a, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (int)a[i];  // zero-extend 8-bit to 32-bit
    }
}

void vec_sxt16(short* a, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (int)a[i];  // sign-extend 16-bit to 32-bit
    }
}

void vec_uxt16(unsigned short* a, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (int)a[i];  // zero-extend 16-bit to 32-bit
    }
}

void vec_narrow_s32_s16(int* a, short* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (short)a[i];  // narrow 32-bit to 16-bit (with saturation concept)
    }
}

int test_main(void) {
    test_printstr("Testing vector extend/narrow...\n");
    
    // Test 1: Sign-extend 8-bit to 32-bit (positive)
    signed char a1[] = {10, 20, 30, 40};
    int c1[4];
    vec_sxt8(a1, c1, 4);
    test_printstr("  sxt8_pos: ");
    TEST_ASSERT(c1[0] == 10);
    TEST_ASSERT(c1[1] == 20);
    TEST_ASSERT(c1[2] == 30);
    TEST_ASSERT(c1[3] == 40);
    test_printstr("OK\n");
    
    // Test 2: Sign-extend 8-bit to 32-bit (negative)
    signed char a2[] = {-10, -20, -30, -40};
    int c2[4];
    vec_sxt8(a2, c2, 4);
    test_printstr("  sxt8_neg: ");
    TEST_ASSERT(c2[0] == -10);
    TEST_ASSERT(c2[1] == -20);
    TEST_ASSERT(c2[2] == -30);
    TEST_ASSERT(c2[3] == -40);
    test_printstr("OK\n");
    
    // Test 3: Zero-extend 8-bit to 32-bit
    unsigned char a3[] = {0x80, 0x90, 0xA0, 0xFF};
    int c3[4];
    vec_uxt8(a3, c3, 4);
    test_printstr("  uxt8: ");
    TEST_ASSERT(c3[0] == 128);
    TEST_ASSERT(c3[1] == 144);
    TEST_ASSERT(c3[2] == 160);
    TEST_ASSERT(c3[3] == 255);
    test_printstr("OK\n");
    
    // Test 4: Sign-extend 16-bit to 32-bit (negative)
    short a4[] = {-1000, -2000, -30000, 10000};
    int c4[4];
    vec_sxt16(a4, c4, 4);
    test_printstr("  sxt16: ");
    TEST_ASSERT(c4[0] == -1000);
    TEST_ASSERT(c4[1] == -2000);
    TEST_ASSERT(c4[2] == -30000);
    TEST_ASSERT(c4[3] == 10000);
    test_printstr("OK\n");
    
    // Test 5: Zero-extend 16-bit to 32-bit
    unsigned short a5[] = {0x8000, 0x9000, 0xFFFF, 0x7FFF};
    int c5[4];
    vec_uxt16(a5, c5, 4);
    test_printstr("  uxt16: ");
    TEST_ASSERT(c5[0] == 0x8000);
    TEST_ASSERT(c5[1] == 0x9000);
    TEST_ASSERT(c5[2] == 0xFFFF);
    TEST_ASSERT(c5[3] == 0x7FFF);
    test_printstr("OK\n");
    
    // Test 6: Narrow 32-bit to 16-bit
    int a6[] = {1000, 2000, 30000, -10000};
    short c6[4];
    vec_narrow_s32_s16(a6, c6, 4);
    test_printstr("  narrow: ");
    TEST_ASSERT(c6[0] == 1000);
    TEST_ASSERT(c6[1] == 2000);
    TEST_ASSERT(c6[2] == 30000);
    TEST_ASSERT(c6[3] == -10000);
    test_printstr("OK\n");
    
    test_printstr("All vector extend/narrow tests passed!\n");
    test_pass();
    return 0;
}
