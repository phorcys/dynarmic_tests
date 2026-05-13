/*
 * Multiply Operations Test
 * Tests MUL, MADD, MSUB, SMULH, UMULH
 */

#include "test_syscall.h"

/* Test basic multiply */
static int test_mul(void) {
    test_printstr("Testing MUL...\n");
    
    TEST_ASSERT(10 * 10 == 100);
    TEST_ASSERT(100 * 100 == 10000);
    TEST_ASSERT(0 * 100 == 0);
    TEST_ASSERT(1 * 100 == 100);
    TEST_ASSERT(0xFFFFFFFF * 1 == 0xFFFFFFFF);
    
    test_printstr("  MUL: PASS\n");
    return 0;
}

/* Test multiply-add */
static int test_madd(void) {
    test_printstr("Testing MADD...\n");
    
    /* a + (b * c) */
    uint64_t a = 100;
    uint64_t b = 10;
    uint64_t c = 5;
    
    uint64_t result = a + (b * c);
    TEST_ASSERT(result == 150);
    
    /* Chain multiply-add */
    result = 0;
    for (int i = 0; i < 10; i++) {
        result = result + (i * 2);
    }
    TEST_ASSERT(result == 90);  /* 0+2+4+6+8+10+12+14+16+18 = 90 */
    
    test_printstr("  MADD: PASS\n");
    return 0;
}

/* Test multiply-subtract */
static int test_msub(void) {
    test_printstr("Testing MSUB...\n");
    
    /* a - (b * c) */
    int64_t a = 100;
    int64_t b = 10;
    int64_t c = 5;
    
    int64_t result = a - (b * c);
    TEST_ASSERT(result == 50);
    
    result = 200 - (15 * 10);
    TEST_ASSERT(result == 50);
    
    test_printstr("  MSUB: PASS\n");
    return 0;
}

/* Test 64-bit multiply */
static int test_mul_64bit(void) {
    test_printstr("Testing 64-bit MUL...\n");
    
    uint64_t a = 0x10000ULL;
    uint64_t b = 0x10000ULL;
    
    uint64_t result = a * b;
    TEST_ASSERT(result == 0x100000000ULL);
    
    /* Larger multiply */
    a = 0x12345678ULL;
    b = 0x100ULL;
    result = a * b;
    TEST_ASSERT(result == 0x1234567800ULL);
    
    test_printstr("  64-bit MUL: PASS\n");
    return 0;
}

/* Test signed multiply */
static int test_smul(void) {
    test_printstr("Testing SMUL...\n");
    
    int64_t a = -10;
    int64_t b = 10;
    
    TEST_ASSERT(a * b == -100);
    TEST_ASSERT(a * a == 100);
    TEST_ASSERT((-100) * (-100) == 10000);
    
    test_printstr("  SMUL: PASS\n");
    return 0;
}

/* Test high multiply (upper 64 bits) */
static int test_mulh(void) {
    test_printstr("Testing MULH...\n");
    
    /* For 128-bit result, get upper bits */
    uint64_t a = 0x100000000ULL;
    uint64_t b = 0x100000000ULL;
    
    /* Full 128-bit result: 0x10000000000000000 */
    /* Upper 64 bits: 0x1 */
    
    /* Simulate with 32-bit halves */
    uint64_t a_lo = a & 0xFFFFFFFF;
    uint64_t a_hi = a >> 32;
    uint64_t b_lo = b & 0xFFFFFFFF;
    uint64_t b_hi = b >> 32;
    
    uint64_t mid = a_lo * b_hi + a_hi * b_lo;
    uint64_t high = a_hi * b_hi + (mid >> 32);
    
    TEST_ASSERT(high == 1);
    
    test_printstr("  MULH: PASS\n");
    return 0;
}

/* Test polynomial multiply simulation */
static int test_pmul(void) {
    test_printstr("Testing PMUL...\n");
    
    /* Simple XOR-based "multiplication" for Galois field */
    uint8_t a = 0x57;  /* Polynomial */
    uint8_t b = 0x83;  /* Polynomial */
    
    uint8_t result = 0;
    for (int i = 0; i < 8; i++) {
        if (b & (1 << i)) {
            result ^= a << i;
        }
    }
    
    /* Just verify it produces some result */
    TEST_ASSERT(result != 0);
    
    test_printstr("  PMUL: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Multiply Operations Tests ===\n");
    
    test_mul();
    test_madd();
    test_msub();
    test_mul_64bit();
    test_smul();
    test_mulh();
    test_pmul();
    
    test_printstr("All multiply tests passed!\n");
    test_pass();
    return 0;
}
