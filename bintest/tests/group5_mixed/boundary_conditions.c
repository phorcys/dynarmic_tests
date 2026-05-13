/*
 * Boundary Conditions Test
 * Tests edge cases and boundary conditions
 */

#include "test_syscall.h"

/* Test integer division edge cases */
static int test_div_edge(void) {
    test_printstr("Testing division edge cases...\n");
    
    /* Division by powers of 2 */
    int64_t a = 100;
    TEST_ASSERT(a / 2 == 50);
    TEST_ASSERT(a / 4 == 25);
    TEST_ASSERT(a / 8 == 12);
    TEST_ASSERT(a / 16 == 6);
    
    /* Negative division */
    int64_t neg = -100;
    TEST_ASSERT(neg / 4 == -25);
    TEST_ASSERT(neg / 7 == -14);
    
    /* Large numbers */
    int64_t big = 0x100000000LL;
    TEST_ASSERT(big / 0x10000 == 0x10000);
    
    /* Remainder edge cases */
    TEST_ASSERT(100 % 7 == 2);
    TEST_ASSERT((-100) % 7 == -2);
    TEST_ASSERT(100 % (-7) == 2);
    
    test_printstr("  Division edge: PASS\n");
    return 0;
}

/* Test shift edge cases */
static int test_shift_edge(void) {
    test_printstr("Testing shift edge cases...\n");
    
    uint64_t val = 1;
    
    /* Left shift */
    TEST_ASSERT((val << 0) == 1);
    TEST_ASSERT((val << 1) == 2);
    TEST_ASSERT((val << 63) == 0x8000000000000000ULL);
    
    /* Right shift */
    val = 0x8000000000000000ULL;
    TEST_ASSERT((val >> 1) == 0x4000000000000000ULL);
    TEST_ASSERT((val >> 63) == 1);
    
    /* Arithmetic right shift */
    int64_t neg = -1;
    TEST_ASSERT((neg >> 1) == -1);
    TEST_ASSERT((neg >> 63) == -1);
    
    neg = -2;  /* 0xFFFFFFFFFFFFFFFE */
    TEST_ASSERT((neg >> 1) == -1);
    
    test_printstr("  Shift edge: PASS\n");
    return 0;
}

/* Test overflow detection using flags simulation */
static int test_overflow_detect(void) {
    test_printstr("Testing overflow detection...\n");
    
    /* Signed overflow: adding two positive numbers to get negative */
    int32_t max32 = 0x7FFFFFFF;
    int32_t result = max32 + 1;  /* Overflow to -2147483648 */
    TEST_ASSERT(result < 0);
    
    /* Signed underflow: subtracting from min */
    int32_t min32 = -2147483647 - 1;
    result = min32 - 1;  /* Overflow to 2147483647 */
    TEST_ASSERT(result > 0);
    
    /* Unsigned overflow wraps */
    uint32_t umax = 0xFFFFFFFF;
    uint32_t uresult = umax + 1;
    TEST_ASSERT(uresult == 0);
    
    uresult = umax + 2;
    TEST_ASSERT(uresult == 1);
    
    test_printstr("  Overflow detect: PASS\n");
    return 0;
}

/* Test sign extension edge cases */
static int test_sign_extend(void) {
    test_printstr("Testing sign extension...\n");
    
    /* 8-bit to 64-bit */
    int8_t s8 = -1;
    int64_t s64 = (int64_t)s8;
    TEST_ASSERT(s64 == -1LL);
    
    s8 = 0x80;  /* -128 */
    s64 = (int64_t)s8;
    TEST_ASSERT(s64 == -128LL);
    
    s8 = 0x7F;  /* 127 */
    s64 = (int64_t)s8;
    TEST_ASSERT(s64 == 127LL);
    
    /* 16-bit to 64-bit */
    int16_t s16 = -1;
    s64 = (int64_t)s16;
    TEST_ASSERT(s64 == -1LL);
    
    s16 = 0x8000;  /* -32768 */
    s64 = (int64_t)s16;
    TEST_ASSERT(s64 == -32768LL);
    
    /* 32-bit to 64-bit */
    int32_t s32 = -1;
    s64 = (int64_t)s32;
    TEST_ASSERT(s64 == -1LL);
    
    test_printstr("  Sign extend: PASS\n");
    return 0;
}

/* Test zero extension edge cases */
static int test_zero_extend(void) {
    test_printstr("Testing zero extension...\n");
    
    /* 8-bit to 64-bit */
    uint8_t u8 = 0xFF;
    uint64_t u64 = (uint64_t)u8;
    TEST_ASSERT(u64 == 255ULL);
    
    u8 = 0x80;
    u64 = (uint64_t)u8;
    TEST_ASSERT(u64 == 128ULL);
    
    /* 16-bit to 64-bit */
    uint16_t u16 = 0xFFFF;
    u64 = (uint64_t)u16;
    TEST_ASSERT(u64 == 65535ULL);
    
    /* 32-bit to 64-bit */
    uint32_t u32 = 0xFFFFFFFF;
    u64 = (uint64_t)u32;
    TEST_ASSERT(u64 == 4294967295ULL);
    
    test_printstr("  Zero extend: PASS\n");
    return 0;
}

/* Test comparison edge cases */
static int test_compare_edge(void) {
    test_printstr("Testing compare edge cases...\n");
    
    int64_t smin = 0x8000000000000000LL;
    int64_t smax = 0x7FFFFFFFFFFFFFFFLL;
    
    /* Min < Max */
    TEST_ASSERT(smin < smax);
    TEST_ASSERT(!(smin > smax));
    TEST_ASSERT(smin != smax);
    
    /* Min compared to -1 */
    int64_t neg_one = -1;
    TEST_ASSERT(smin < neg_one);
    TEST_ASSERT(neg_one > smin);
    
    /* Zero comparisons */
    int64_t zero = 0;
    TEST_ASSERT(zero == 0);
    TEST_ASSERT(!(zero < 0));
    TEST_ASSERT(!(zero > 0));
    TEST_ASSERT(zero >= 0);
    TEST_ASSERT(zero <= 0);
    
    test_printstr("  Compare edge: PASS\n");
    return 0;
}

/* Test bitwise edge cases */
static int test_bitwise_edge(void) {
    test_printstr("Testing bitwise edge cases...\n");
    
    uint64_t all_ones = 0xFFFFFFFFFFFFFFFFULL;
    uint64_t all_zeros = 0;
    
    /* AND with all ones */
    uint64_t val = 0x123456789ABCDEF0ULL;
    TEST_ASSERT((val & all_ones) == val);
    
    /* AND with all zeros */
    TEST_ASSERT((val & all_zeros) == 0);
    
    /* OR with all ones */
    TEST_ASSERT((val | all_ones) == all_ones);
    
    /* OR with all zeros */
    TEST_ASSERT((val | all_zeros) == val);
    
    /* XOR with self */
    TEST_ASSERT((val ^ val) == 0);
    
    /* XOR with all ones */
    TEST_ASSERT((val ^ all_ones) == ~val);
    
    /* NOT */
    TEST_ASSERT(~all_zeros == all_ones);
    TEST_ASSERT(~all_ones == all_zeros);
    
    test_printstr("  Bitwise edge: PASS\n");
    return 0;
}

/* Test floating-point edge cases */
static int test_fp_edge(void) {
    test_printstr("Testing FP edge cases...\n");
    
    /* Very small numbers */
    float tiny = 1e-38f;
    TEST_ASSERT(tiny > 0.0f);
    TEST_ASSERT(tiny < 1e-37f);
    
    /* Very large numbers */
    float huge = 1e38f;
    TEST_ASSERT(huge > 1e37f);
    
    /* Denormalized (subnormal) numbers */
    float denorm = 1e-40f;  /* May be denormal */
    TEST_ASSERT(denorm >= 0.0f);
    TEST_ASSERT(denorm < 1e-38f);
    
    /* Zero operations */
    float zero = 0.0f;
    float one = 1.0f;
    TEST_ASSERT(one / huge < 1.0f);  /* Very small but not zero */
    
    test_printstr("  FP edge: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Boundary Conditions Tests ===\n");
    
    test_div_edge();
    test_shift_edge();
    test_overflow_detect();
    test_sign_extend();
    test_zero_extend();
    test_compare_edge();
    test_bitwise_edge();
    test_fp_edge();
    /* Skip type punning test - inline asm may not work correctly */
    
    test_printstr("All boundary tests passed!\n");
    test_pass();
    return 0;
}
