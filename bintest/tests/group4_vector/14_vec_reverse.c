// Test vector reverse and permute operations
#include "test_syscall.h"

void vec_reverse8(unsigned char* a, unsigned char* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[n - 1 - i];
    }
}

void vec_reverse32(int* a, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[n - 1 - i];
    }
}

void vec_swap_pairs(int* a, int* c, int n) {
    for (int i = 0; i < n; i += 2) {
        c[i] = a[i + 1];
        c[i + 1] = a[i];
    }
}

void vec_interleave(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[2*i] = a[i];
        c[2*i + 1] = b[i];
    }
}

void vec_deinterleave(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        a[i] = c[2*i];
        b[i] = c[2*i + 1];
    }
}

unsigned char reverse_bits(unsigned char b) {
    b = (b & 0xF0) >> 4 | (b & 0x0F) << 4;
    b = (b & 0xCC) >> 2 | (b & 0x33) << 2;
    b = (b & 0xAA) >> 1 | (b & 0x55) << 1;
    return b;
}

int test_main(void) {
    test_printstr("Testing vector reverse/permute...\n");
    
    // Test 1: Reverse bytes
    unsigned char a1[] = {1, 2, 3, 4, 5, 6, 7, 8};
    unsigned char c1[8];
    vec_reverse8(a1, c1, 8);
    test_printstr("  rev8: ");
    TEST_ASSERT(c1[0] == 8);
    TEST_ASSERT(c1[1] == 7);
    TEST_ASSERT(c1[2] == 6);
    TEST_ASSERT(c1[3] == 5);
    TEST_ASSERT(c1[4] == 4);
    TEST_ASSERT(c1[5] == 3);
    TEST_ASSERT(c1[6] == 2);
    TEST_ASSERT(c1[7] == 1);
    test_printstr("OK\n");
    
    // Test 2: Reverse 32-bit words
    int a2[] = {100, 200, 300, 400};
    int c2[4];
    vec_reverse32(a2, c2, 4);
    test_printstr("  rev32: ");
    TEST_ASSERT(c2[0] == 400);
    TEST_ASSERT(c2[1] == 300);
    TEST_ASSERT(c2[2] == 200);
    TEST_ASSERT(c2[3] == 100);
    test_printstr("OK\n");
    
    // Test 3: Swap pairs
    int a3[] = {1, 2, 3, 4, 5, 6, 7, 8};
    int c3[8];
    vec_swap_pairs(a3, c3, 8);
    test_printstr("  swap: ");
    TEST_ASSERT(c3[0] == 2 && c3[1] == 1);
    TEST_ASSERT(c3[2] == 4 && c3[3] == 3);
    TEST_ASSERT(c3[4] == 6 && c3[5] == 5);
    TEST_ASSERT(c3[6] == 8 && c3[7] == 7);
    test_printstr("OK\n");
    
    // Test 4: Interleave
    int a4[] = {1, 2, 3, 4};
    int b4[] = {10, 20, 30, 40};
    int c4[8];
    vec_interleave(a4, b4, c4, 4);
    test_printstr("  zip: ");
    TEST_ASSERT(c4[0] == 1);
    TEST_ASSERT(c4[1] == 10);
    TEST_ASSERT(c4[2] == 2);
    TEST_ASSERT(c4[3] == 20);
    TEST_ASSERT(c4[4] == 3);
    TEST_ASSERT(c4[5] == 30);
    TEST_ASSERT(c4[6] == 4);
    TEST_ASSERT(c4[7] == 40);
    test_printstr("OK\n");
    
    // Test 5: Deinterleave (unzip)
    int d5[4], e5[4];
    vec_deinterleave(d5, e5, c4, 4);
    test_printstr("  unzip: ");
    TEST_ASSERT(d5[0] == 1 && d5[1] == 2 && d5[2] == 3 && d5[3] == 4);
    TEST_ASSERT(e5[0] == 10 && e5[1] == 20 && e5[2] == 30 && e5[3] == 40);
    test_printstr("OK\n");
    
    // Test 6: Bit reverse
    unsigned char a6 = 0b11010010;
    unsigned char c6 = reverse_bits(a6);
    test_printstr("  bitrev: ");
    TEST_ASSERT(c6 == 0b01001011);
    test_printstr("OK\n");
    
    test_printstr("All vector reverse/permute tests passed!\n");
    test_pass();
    return 0;
}
