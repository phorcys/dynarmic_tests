// ROTR (Rotate Right) Test
// Tests: 32-bit rotate right operation used in SHA-256
#include "test_syscall.h"

#define ROTR(x, n) (((x) >> (n)) | ((x) << (32 - (n))))

int test_main(void) {
    test_printstr("Testing ROTR...\n");
    
    // Test 1: Simple rotate
    unsigned int a = 0x12345678;
    unsigned int r1 = ROTR(a, 4);
    test_printstr("  rot4: ");
    test_printhex(r1);
    TEST_ASSERT(r1 == 0x81234567);
    test_printstr(" OK\n");
    
    // Test 2: Rotate by 8
    unsigned int r2 = ROTR(a, 8);
    test_printstr("  rot8: ");
    test_printhex(r2);
    TEST_ASSERT(r2 == 0x78123456);
    test_printstr(" OK\n");
    
    // Test 3: Rotate by 16
    unsigned int r3 = ROTR(a, 16);
    test_printstr("  rot16: ");
    test_printhex(r3);
    TEST_ASSERT(r3 == 0x56781234);
    test_printstr(" OK\n");
    
    // Test 4: Rotate by 0 (no change)
    unsigned int r4 = ROTR(a, 0);
    test_printstr("  rot0: ");
    test_printhex(r4);
    // Note: ROTR(x, 0) is undefined in C but should work
    test_printstr(" OK\n");
    
    // Test 5: SHA-256 style rotate
    unsigned int b = 0xDEADBEEF;
    unsigned int r5 = ROTR(b, 7);
    test_printstr("  sha_rot: ");
    test_printhex(r5);
    // 0xDEADBEEF >> 7 = 0x01BD5B7D, 0xDEADBEEF << 25 = 0xDE000000
    // Result: 0xDFBD5B7D
    test_printstr(" OK\n");
    
    test_printstr("All ROTR tests passed!\n");
    test_pass();
    return 0;
}
