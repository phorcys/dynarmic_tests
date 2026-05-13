/*
 * Integer Overflow and Boundary Tests
 * Tests overflow detection, carry, and boundary conditions
 */

#include "test_syscall.h"

/* Test signed overflow detection */
static int test_signed_overflow(void) {
    test_printstr("Testing signed overflow...\n");
    
    volatile int64_t max = 0x7FFFFFFFFFFFFFFFLL;
    volatile int64_t min = 0x8000000000000000LL;
    
    /* Test INT64_MAX + 1 (should overflow) */
    volatile int64_t result = max + 1;
    TEST_ASSERT(result == min);  /* Wraps to minimum */
    
    /* Test INT64_MIN - 1 (should underflow) */
    result = min - 1;
    TEST_ASSERT(result == max);  /* Wraps to maximum */
    
    /* Test negation of INT64_MIN */
    result = -min;
    TEST_ASSERT(result == min);  /* Stays min (overflow) */
    
    test_printstr("  Signed overflow: PASS\n");
    return 0;
}

/* Test unsigned overflow/wraparound */
static int test_unsigned_overflow(void) {
    test_printstr("Testing unsigned overflow...\n");
    
    volatile uint64_t max = 0xFFFFFFFFFFFFFFFFULL;
    volatile uint64_t zero = 0;
    
    /* Test UINT64_MAX + 1 (should wrap to 0) */
    volatile uint64_t result = max + 1;
    TEST_ASSERT(result == 0);
    
    /* Test 0 - 1 (should wrap to max) */
    result = zero - 1;
    TEST_ASSERT(result == max);
    
    /* Test multiplication overflow */
    result = max * 2;
    TEST_ASSERT(result == max - 1);  /* (2^64 - 1) * 2 = 2^65 - 2 = -2 mod 2^64 */
    
    test_printstr("  Unsigned overflow: PASS\n");
    return 0;
}

/* Test carry chain operations */
static int test_carry_chain(void) {
    test_printstr("Testing carry chain...\n");
    
    uint64_t a = 0xFFFFFFFF00000000ULL;
    uint64_t b = 0x0000000100000000ULL;
    
    /* a + b should produce carry from lower to upper 32 bits */
    uint64_t result = a + b;
    TEST_ASSERT(result == 0x0000000000000000ULL);  /* With carry out */
    
    /* Test extended addition */
    uint64_t c = 0xFFFFFFFFFFFFFFFFULL;
    uint64_t d = 0x0000000000000001ULL;
    result = c + d;
    TEST_ASSERT(result == 0);
    
    test_printstr("  Carry chain: PASS\n");
    return 0;
}

/* Test 32-bit vs 64-bit operations */
static int test_32_64_mixed(void) {
    test_printstr("Testing 32/64-bit mixed operations...\n");
    
    /* 32-bit sign extension */
    int32_t s32 = -1;
    int64_t s64 = (int64_t)s32;
    TEST_ASSERT(s64 == -1LL);
    TEST_ASSERT(s64 == 0xFFFFFFFFFFFFFFFFULL);
    
    /* 32-bit zero extension */
    uint32_t u32 = 0xFFFFFFFFU;
    uint64_t u64 = (uint64_t)u32;
    TEST_ASSERT(u64 == 0x00000000FFFFFFFFULL);
    
    /* 32-bit arithmetic should truncate */
    uint32_t a = 0x80000000U;
    uint32_t b = a + a;
    TEST_ASSERT(b == 0);  /* Overflow truncated */
    
    test_printstr("  32/64-bit mixed: PASS\n");
    return 0;
}

/* Test division edge cases */
static int test_division_edge(void) {
    test_printstr("Testing division edge cases...\n");
    
    /* Division by powers of 2 */
    TEST_ASSERT(100 / 4 == 25);
    TEST_ASSERT(100 / 8 == 12);
    TEST_ASSERT((-100) / 4 == -25);
    
    /* Modulo edge cases */
    TEST_ASSERT(100 % 7 == 2);
    TEST_ASSERT((-100) % 7 == -2);  /* C99: result has sign of dividend */
    TEST_ASSERT(100 % (-7) == 2);
    
    /* Large number division */
    uint64_t big = 0x1000000000000000ULL;
    TEST_ASSERT(big / 16 == 0x0100000000000000ULL);
    
    test_printstr("  Division edge: PASS\n");
    return 0;
}

/* Test shift edge cases */
static int test_shift_edge(void) {
    test_printstr("Testing shift edge cases...\n");
    
    uint64_t val = 1;
    
    /* Left shift by 63 */
    TEST_ASSERT((val << 63) == 0x8000000000000000ULL);
    
    /* Right shift by 63 */
    TEST_ASSERT((0x8000000000000000ULL >> 63) == 1);
    
    /* Arithmetic right shift of negative number */
    int64_t neg = -1;
    TEST_ASSERT((neg >> 32) == -1);  /* Sign extended */
    
    int64_t neg2 = -2;  /* 0xFFFFFFFFFFFFFFFE */
    TEST_ASSERT((neg2 >> 1) == -1);  /* -2 >> 1 = -1 */
    
    /* Shift by 0 */
    TEST_ASSERT((val << 0) == 1);
    TEST_ASSERT((val >> 0) == 1);
    
    test_printstr("  Shift edge: PASS\n");
    return 0;
}

/* Test compare edge cases */
static int test_compare_edge(void) {
    test_printstr("Testing compare edge cases...\n");
    
    volatile int64_t smin = 0x8000000000000000LL;
    volatile int64_t smax = 0x7FFFFFFFFFFFFFFFLL;
    volatile uint64_t umax = 0xFFFFFFFFFFFFFFFFULL;
    
    /* Signed compare: min < max */
    TEST_ASSERT(smin < smax);
    TEST_ASSERT(!(smin > smax));
    
    /* Compare with zero */
    TEST_ASSERT(0 == 0);
    TEST_ASSERT(!(0 < 0));
    TEST_ASSERT(!(0 > 0));
    TEST_ASSERT(0 <= 0);
    TEST_ASSERT(0 >= 0);
    
    test_printstr("  Compare edge: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Integer Overflow Tests ===\n");
    
    test_signed_overflow();
    test_unsigned_overflow();
    test_carry_chain();
    test_32_64_mixed();
    test_division_edge();
    test_shift_edge();
    test_compare_edge();
    
    test_printstr("=== All integer overflow tests passed ===\n");
    test_pass();
    return 0;
}
