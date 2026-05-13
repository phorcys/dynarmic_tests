/*
 * Division and Remainder Test
 * Tests SDIV, UDIV, remainder operations
 */

#include "test_syscall.h"

/* Test unsigned division */
static int test_udiv(void) {
    test_printstr("Testing UDIV...\n");
    
    TEST_ASSERT(100 / 10 == 10);
    TEST_ASSERT(100 / 3 == 33);
    TEST_ASSERT(0 / 5 == 0);
    TEST_ASSERT(1 / 1 == 1);
    TEST_ASSERT(0xFFFFFFFF / 0x100 == 0xFFFFFF);
    
    test_printstr("  UDIV: PASS\n");
    return 0;
}

/* Test signed division */
static int test_sdiv(void) {
    test_printstr("Testing SDIV...\n");
    
    TEST_ASSERT(100 / 10 == 10);
    TEST_ASSERT((-100) / 10 == -10);
    TEST_ASSERT(100 / (-10) == -10);
    TEST_ASSERT((-100) / (-10) == 10);
    
    int64_t a = -1000000000LL;
    int64_t b = 7;
    TEST_ASSERT(a / b == -142857142);
    
    test_printstr("  SDIV: PASS\n");
    return 0;
}

/* Test remainder */
static int test_remainder(void) {
    test_printstr("Testing remainder...\n");
    
    TEST_ASSERT(100 % 10 == 0);
    TEST_ASSERT(100 % 7 == 2);
    TEST_ASSERT(10 % 3 == 1);
    TEST_ASSERT(7 % 10 == 7);
    
    /* Negative numbers */
    int a = -100;
    int b = 7;
    int r = a % b;
    TEST_ASSERT(r == -2 || r == 5);  /* Implementation-defined sign */
    
    test_printstr("  Remainder: PASS\n");
    return 0;
}

/* Test division edge cases */
static int test_div_edge_cases(void) {
    test_printstr("Testing div edge cases...\n");
    
    /* Divide max value */
    uint64_t max = 0xFFFFFFFFFFFFFFFFULL;
    TEST_ASSERT(max / 1 == max);
    TEST_ASSERT(max / 2 == 0x7FFFFFFFFFFFFFFFULL);
    
    /* Divide by power of 2 */
    TEST_ASSERT(1024 / 4 == 256);
    TEST_ASSERT(1024 / 8 == 128);
    TEST_ASSERT(1024 / 64 == 16);
    
    test_printstr("  Div edge cases: PASS\n");
    return 0;
}

/* Test 64-bit division */
static int test_div_64bit(void) {
    test_printstr("Testing 64-bit div...\n");
    
    /* Simple 64-bit division */
    uint64_t a = 0x100000000ULL;  /* 2^32 */
    uint64_t b = 0x10000ULL;      /* 2^16 */
    
    uint64_t q = a / b;
    TEST_ASSERT(q == 0x10000ULL);  /* 2^16 */
    
    /* Another test */
    uint64_t c = 1000000000000ULL;
    uint64_t d = 1000000ULL;
    TEST_ASSERT(c / d == 1000000ULL);
    
    test_printstr("  64-bit div: PASS\n");
    return 0;
}

/* Test division combined with other ops */
static int test_div_combined(void) {
    test_printstr("Testing div combined...\n");
    
    /* Compute average */
    int sum = 150;
    int count = 3;
    int avg = sum / count;
    TEST_ASSERT(avg == 50);
    
    /* Scale calculation */
    int value = 12345;
    int scale = 100;
    int scaled = value * scale / 1000;
    TEST_ASSERT(scaled == 1234);
    
    test_printstr("  Div combined: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Division and Remainder Tests ===\n");
    
    test_udiv();
    test_sdiv();
    test_remainder();
    test_div_edge_cases();
    test_div_64bit();
    test_div_combined();
    
    test_printstr("All division tests passed!\n");
    test_pass();
    return 0;
}
