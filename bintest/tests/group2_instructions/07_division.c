// Test division and modulo instructions
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing division instructions...\n");
    
    // Test 1: Basic signed division
    int r1 = 100 / 7;
    test_printstr("  100 / 7 = ");
    test_printint(r1);
    TEST_ASSERT(r1 == 14);
    
    // Test 2: Signed modulo
    int r2 = 100 % 7;
    test_printstr("\n  100 % 7 = ");
    test_printint(r2);
    TEST_ASSERT(r2 == 2);
    
    // Test 3: Negative division
    int r3 = -100 / 7;
    test_printstr("\n  -100 / 7 = ");
    test_printint(r3);
    TEST_ASSERT(r3 == -14);
    
    // Test 4: Negative modulo
    int r4 = -100 % 7;
    test_printstr("\n  -100 % 7 = ");
    test_printint(r4);
    TEST_ASSERT(r4 == -2);
    
    // Test 5: Both negative
    int r5 = -100 / -7;
    int r6 = -100 % -7;
    test_printstr("\n  -100 / -7 = ");
    test_printint(r5);
    test_printstr(", -100 % -7 = ");
    test_printint(r6);
    TEST_ASSERT(r5 == 14 && r6 == -2);
    
    // Test 6: Unsigned division
    unsigned int r7 = 0xFFFFFFFF / 16;
    test_printstr("\n  0xFFFFFFFF / 16 = ");
    test_printhex(r7);
    TEST_ASSERT(r7 == 0x0FFFFFFF);
    
    // Test 7: Unsigned modulo
    unsigned int r8 = 0xFFFFFFFF % 16;
    test_printstr("\n  0xFFFFFFFF % 16 = ");
    test_printhex(r8);
    TEST_ASSERT(r8 == 0xF);
    
    // Test 8: 64-bit division
    long long r9 = 1000000000000LL / 1000000LL;
    test_printstr("\n  1000000000000 / 1000000 = ");
    test_printint((int)r9);
    TEST_ASSERT(r9 == 1000000);
    
    // Test 9: Verify quotient * divisor + remainder == dividend
    int a = 12345, b = 67;
    int q = a / b;
    int m = a % b;
    test_printstr("\n  Verify: q*d+r = ");
    test_printint(q * b + m);
    TEST_ASSERT(q * b + m == a);
    
    test_printstr("\nAll division tests passed!\n");
    test_pass();
    return 0;
}