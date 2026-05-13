/*
 * Load Literal Test
 * Tests LDR (literal), LDRSW (literal) patterns
 */

#include "test_syscall.h"

/* Literal pool simulation */
static const uint64_t literal_u64[] = {
    0x123456789ABCDEF0ULL,
    0xFEDCBA9876543210ULL,
    0x0000000000000001ULL,
    0xFFFFFFFFFFFFFFFFULL
};

static const int64_t literal_s64[] = {
    -1,
    -1000000,
    0,
    1000000
};

static const uint32_t literal_u32[] = {
    0x12345678,
    0x9ABCDEF0,
    0x00000001,
    0xFFFFFFFF
};

/* Test load 64-bit literal */
static int test_ldr_literal64(void) {
    test_printstr("Testing LDR literal64...\n");
    
    uint64_t val = literal_u64[0];
    TEST_ASSERT(val == 0x123456789ABCDEF0ULL);
    
    val = literal_u64[3];
    TEST_ASSERT(val == 0xFFFFFFFFFFFFFFFFULL);
    
    test_printstr("  LDR literal64: PASS\n");
    return 0;
}

/* Test load signed 64-bit literal */
static int test_ldrsw_literal(void) {
    test_printstr("Testing LDRSW literal...\n");
    
    int64_t val = literal_s64[0];
    TEST_ASSERT(val == -1);
    
    val = literal_s64[3];
    TEST_ASSERT(val == 1000000);
    
    test_printstr("  LDRSW literal: PASS\n");
    return 0;
}

/* Test load 32-bit literal */
static int test_ldr_literal32(void) {
    test_printstr("Testing LDR literal32...\n");
    
    uint32_t val = literal_u32[0];
    TEST_ASSERT(val == 0x12345678);
    
    val = literal_u32[3];
    TEST_ASSERT(val == 0xFFFFFFFF);
    
    test_printstr("  LDR literal32: PASS\n");
    return 0;
}

/* Test PC-relative addressing */
static int test_pcrel(void) {
    test_printstr("Testing PC-relative...\n");
    
    /* Get address of literal pool */
    const uint64_t *ptr = &literal_u64[0];
    
    /* Verify we can read through the pointer */
    TEST_ASSERT(ptr[0] == 0x123456789ABCDEF0ULL);
    TEST_ASSERT(ptr[1] == 0xFEDCBA9876543210ULL);
    
    test_printstr("  PC-relative: PASS\n");
    return 0;
}

/* Test floating point literal */
static int test_fp_literal(void) {
    test_printstr("Testing FP literal...\n");
    
    static const double pi = 3.14159265358979;
    static const double e = 2.71828182845904;
    
    TEST_ASSERT(pi > 3.14 && pi < 3.15);
    TEST_ASSERT(e > 2.71 && e < 2.72);
    
    /* Use the values to prevent optimization */
    double sum = pi + e;
    TEST_ASSERT(sum > 5.85 && sum < 5.87);
    
    test_printstr("  FP literal: PASS\n");
    return 0;
}

/* Test string literal */
static int test_string_literal(void) {
    test_printstr("Testing string literal...\n");
    
    static const char str[] = "Hello, World!";
    
    TEST_ASSERT(str[0] == 'H');
    TEST_ASSERT(str[12] == '!');
    TEST_ASSERT(str[13] == '\0');
    
    test_printstr("  String literal: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Load Literal Tests ===\n");
    
    test_ldr_literal64();
    test_ldrsw_literal();
    test_ldr_literal32();
    test_pcrel();
    test_fp_literal();
    test_string_literal();
    
    test_printstr("All load literal tests passed!\n");
    test_pass();
    return 0;
}
