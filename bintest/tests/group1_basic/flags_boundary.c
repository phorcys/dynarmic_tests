/*
 * Flags Boundary Test
 * Tests NZCV flags edge cases
 */

#include "test_syscall.h"

/* Test overflow detection */
static int test_overflow(void) {
    test_printstr("Testing overflow...\n");
    
    int32_t max = 0x7FFFFFFF;
    int32_t min = 0x80000000;
    
    /* Signed overflow */
    int32_t ovf1 = max + 1;  /* Overflow to min */
    TEST_ASSERT(ovf1 == min);
    
    int32_t ovf2 = min - 1;  /* Underflow to max */
    TEST_ASSERT(ovf2 == max);
    
    /* No overflow */
    int32_t ok1 = max - 1;
    TEST_ASSERT(ok1 == max - 1);
    
    int32_t ok2 = min + 1;
    TEST_ASSERT(ok2 == min + 1);
    
    test_printstr("  Overflow: PASS\n");
    return 0;
}

/* Test carry detection */
static int test_carry(void) {
    test_printstr("Testing carry...\n");
    
    uint32_t umax = 0xFFFFFFFF;
    
    /* Unsigned overflow (carry) */
    uint32_t c1 = umax + 1;
    TEST_ASSERT(c1 == 0);
    
    uint32_t c2 = umax + 2;
    TEST_ASSERT(c2 == 1);
    
    /* Borrow */
    uint32_t b1 = 0 - 1;
    TEST_ASSERT(b1 == umax);
    
    test_printstr("  Carry: PASS\n");
    return 0;
}

/* Test zero flag */
static int test_zero(void) {
    test_printstr("Testing zero flag...\n");
    
    int32_t a = 100;
    int32_t b = 100;
    int32_t c = a - b;
    TEST_ASSERT(c == 0);
    
    int32_t d = 0;
    int32_t e = 0 - d;
    TEST_ASSERT(e == 0);
    
    test_printstr("  Zero: PASS\n");
    return 0;
}

/* Test negative flag */
static int test_negative(void) {
    test_printstr("Testing negative flag...\n");
    
    int32_t a = 100;
    int32_t b = 200;
    int32_t c = a - b;
    TEST_ASSERT(c < 0);
    
    int32_t d = -1;
    TEST_ASSERT(d < 0);
    
    int32_t e = 0x80000000;
    TEST_ASSERT(e < 0);
    
    test_printstr("  Negative: PASS\n");
    return 0;
}

/* Test comparison results */
static int test_cmp(void) {
    test_printstr("Testing CMP...\n");
    
    int32_t a = 100;
    int32_t b = 200;
    int32_t c = 100;
    
    /* a < b */
    TEST_ASSERT(a < b);
    TEST_ASSERT(!(b < a));
    
    /* a == c */
    TEST_ASSERT(a == c);
    TEST_ASSERT(!(a < c));
    TEST_ASSERT(!(c < a));
    
    /* b > a */
    TEST_ASSERT(b > a);
    TEST_ASSERT(!(a > b));
    
    test_printstr("  CMP: PASS\n");
    return 0;
}

/* Test conditional select */
static int test_csel(void) {
    test_printstr("Testing CSEL...\n");
    
    int32_t a = 10;
    int32_t b = 20;
    int32_t c = 30;
    int32_t d = 40;
    
    /* Select based on condition */
    int32_t r1 = (a < b) ? c : d;
    TEST_ASSERT(r1 == c);
    
    int32_t r2 = (a > b) ? c : d;
    TEST_ASSERT(r2 == d);
    
    int32_t r3 = (a == 10) ? a : b;
    TEST_ASSERT(r3 == 10);
    
    test_printstr("  CSEL: PASS\n");
    return 0;
}

/* Test conditional increment/decrement */
static int test_csinc(void) {
    test_printstr("Testing CSINC...\n");
    
    int32_t a = 5;
    int32_t b = 10;
    
    /* Conditional increment */
    int32_t r1 = (a == a) ? b : (b + 1);
    TEST_ASSERT(r1 == 10);
    
    int32_t r2 = (a != a) ? b : (b + 1);
    TEST_ASSERT(r2 == 11);
    
    /* CSET equivalent */
    int32_t one = (a == a) ? 1 : 0;
    TEST_ASSERT(one == 1);
    
    int32_t zero = (a != a) ? 1 : 0;
    TEST_ASSERT(zero == 0);
    
    test_printstr("  CSINC: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Flags Boundary Tests ===\n");
    
    test_overflow();
    test_carry();
    test_zero();
    test_negative();
    test_cmp();
    test_csel();
    test_csinc();
    
    test_printstr("All flags boundary tests passed!\n");
    test_pass();
    return 0;
}
