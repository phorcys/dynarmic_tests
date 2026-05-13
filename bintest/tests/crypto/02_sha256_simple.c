// Simplified SHA-256 test for debugging
#include "test_syscall.h"

#define ROTR(x, n) (((x) >> (n)) | ((x) << (32 - (n))))

int test_main(void) {
    test_printstr("Test 1: Simple shift...\n");
    unsigned int x = 0x12345678;
    unsigned int r = ROTR(x, 4);
    // ROTR(0x12345678, 4) = 0x81234567
    if (r != 0x81234567) {
        test_printstr("  ROTR failed!\n");
        TEST_ASSERT(0);
    }
    test_printstr("  ROTR OK\n");
    
    test_printstr("Test 2: XOR...\n");
    unsigned int a = 0xFF00FF00;
    unsigned int b = 0x0F0F0F0F;
    unsigned int c = a ^ b;
    if (c != 0xF00FF00F) {
        test_printstr("  XOR failed!\n");
        TEST_ASSERT(0);
    }
    test_printstr("  XOR OK\n");
    
    test_printstr("Test 3: Addition...\n");
    unsigned int d = 0xFFFFFFFF;
    unsigned int e = d + 1;  // Should wrap to 0
    if (e != 0) {
        test_printstr("  ADD wrap failed!\n");
        TEST_ASSERT(0);
    }
    test_printstr("  ADD wrap OK\n");
    
    test_printstr("Test 4: Shift right logical...\n");
    unsigned int f = 0x80000001;
    unsigned int g = f >> 1;  // Should be 0x40000000 (logical shift)
    if (g != 0x40000000) {
        test_printstr("  SHR failed! got: ");
        // Print hex
        for (int i = 28; i >= 0; i -= 4) {
            int digit = (g >> i) & 0xF;
            test_putchar(digit < 10 ? '0' + digit : 'a' + digit - 10);
        }
        test_putchar('\n');
        TEST_ASSERT(0);
    }
    test_printstr("  SHR OK\n");
    
    test_printstr("All simple tests passed!\n");
    test_pass();
    return 0;
}
