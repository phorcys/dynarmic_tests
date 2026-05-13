// Test bit manipulation operations
#include "test_syscall.h"

int count_bits(unsigned int x) {
    int count = 0;
    while (x) {
        count += x & 1;
        x >>= 1;
    }
    return count;
}

unsigned int reverse_bits(unsigned int x) {
    unsigned int result = 0;
    for (int i = 0; i < 32; i++) {
        result = (result << 1) | (x & 1);
        x >>= 1;
    }
    return result;
}

int test_main(void) {
    test_printstr("Testing bit operations...\n");
    
    // Test 1: Count bits
    int r1 = count_bits(0xD5);
    test_printstr("  count_bits(0xD5): ");
    test_printint(r1);
    TEST_ASSERT(r1 == 5);
    
    // Test 2: Reverse bits
    unsigned int r2 = reverse_bits(0x12345678);
    test_printstr("\n  reverse_bits(0x12345678): ");
    test_printhex(r2);
    TEST_ASSERT(r2 == 0x1E6A2C48);
    
    // Test 3: Bit masking
    unsigned int x = 0x12345678;
    unsigned int masked = x & 0x00FF0000;
    test_printstr("\n  mask 0x12345678 & 0x00FF0000: ");
    test_printhex(masked);
    TEST_ASSERT(masked == 0x00340000);
    
    // Test 4: Bit setting
    unsigned int y = 0x00001000;
    unsigned int set = y | 0x00000001;
    test_printstr("\n  set bit 0: ");
    test_printhex(set);
    TEST_ASSERT(set == 0x00001001);
    
    // Test 5: Bit clearing
    unsigned int cleared = set & ~0x00001000;
    test_printstr("\n  clear bit 12: ");
    test_printhex(cleared);
    TEST_ASSERT(cleared == 0x00000001);
    
    // Test 6: Bit toggling
    unsigned int toggled = cleared ^ 0x00000001;
    test_printstr("\n  toggle bit 0: ");
    test_printhex(toggled);
    TEST_ASSERT(toggled == 0x00000000);
    
    // Test 7: Shift left
    unsigned int sl = 0x1234 << 8;
    test_printstr("\n  0x1234 << 8: ");
    test_printhex(sl);
    TEST_ASSERT(sl == 0x123400);
    
    // Test 8: Shift right
    unsigned int sr = 0x12345678 >> 4;
    test_printstr("\n  0x12345678 >> 4: ");
    test_printhex(sr);
    TEST_ASSERT(sr == 0x01234567);
    
    test_printstr("\nAll bit operation tests passed!\n");
    test_pass();
    return 0;
}