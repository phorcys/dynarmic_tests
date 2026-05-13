/*
 * Conditional Selection Test
 * Tests CSEL, CSINC, CSINV, CSNEG, CSET, CINC instructions
 */

#include "test_syscall.h"

/* Conditional select */
static uint64_t csel(uint64_t a, uint64_t b, int cond) {
    return cond ? a : b;
}

/* Conditional select increment */
static uint64_t csinc(uint64_t a, uint64_t b, int cond) {
    return cond ? a : (b + 1);
}

/* Conditional select invert */
static uint64_t csinv(uint64_t a, uint64_t b, int cond) {
    return cond ? a : (~b);
}

/* Conditional select negate */
static uint64_t csneg(uint64_t a, uint64_t b, int cond) {
    return cond ? a : (-(int64_t)b);
}

/* Conditional set */
static uint64_t cset(int cond) {
    return cond ? 1 : 0;
}

/* Conditional increment */
static uint64_t cinc(uint64_t a, int cond) {
    return cond ? (a + 1) : a;
}

/* Test CSEL */
static int test_csel(void) {
    test_printstr("Testing CSEL...\n");
    
    TEST_ASSERT(csel(100, 200, 1) == 100);
    TEST_ASSERT(csel(100, 200, 0) == 200);
    TEST_ASSERT(csel(0xFFFFFFFF, 0, 1) == 0xFFFFFFFF);
    TEST_ASSERT(csel(0xFFFFFFFF, 0, 0) == 0);
    
    test_printstr("  CSEL: PASS\n");
    return 0;
}

/* Test CSINC */
static int test_csinc(void) {
    test_printstr("Testing CSINC...\n");
    
    TEST_ASSERT(csinc(100, 200, 1) == 100);
    TEST_ASSERT(csinc(100, 200, 0) == 201);
    TEST_ASSERT(csinc(0, 0, 0) == 1);  /* Increment from 0 */
    TEST_ASSERT(csinc(0, 0xFF, 0) == 0x100);
    
    test_printstr("  CSINC: PASS\n");
    return 0;
}

/* Test CSINV */
static int test_csinv(void) {
    test_printstr("Testing CSINV...\n");
    
    TEST_ASSERT(csinv(100, 200, 1) == 100);
    TEST_ASSERT(csinv(100, 0, 0) == 0xFFFFFFFFFFFFFFFFULL);
    TEST_ASSERT(csinv(0, 0x0F, 0) == 0xFFFFFFFFFFFFFFF0ULL);
    
    test_printstr("  CSINV: PASS\n");
    return 0;
}

/* Test CSNEG */
static int test_csneg(void) {
    test_printstr("Testing CSNEG...\n");
    
    TEST_ASSERT(csneg(100, 200, 1) == 100);
    TEST_ASSERT((int64_t)csneg(100, 50, 0) == -50);
    TEST_ASSERT((int64_t)csneg(100, 0, 0) == 0);
    TEST_ASSERT((int64_t)csneg(100, 1, 0) == -1);
    
    test_printstr("  CSNEG: PASS\n");
    return 0;
}

/* Test CSET */
static int test_cset(void) {
    test_printstr("Testing CSET...\n");
    
    TEST_ASSERT(cset(1) == 1);
    TEST_ASSERT(cset(0) == 0);
    
    test_printstr("  CSET: PASS\n");
    return 0;
}

/* Test CINC */
static int test_cinc(void) {
    test_printstr("Testing CINC...\n");
    
    TEST_ASSERT(cinc(100, 1) == 101);
    TEST_ASSERT(cinc(100, 0) == 100);
    TEST_ASSERT(cinc(0, 1) == 1);
    
    test_printstr("  CINC: PASS\n");
    return 0;
}

/* Test conditional chains */
static int test_conditional_chains(void) {
    test_printstr("Testing conditional chains...\n");
    
    int a = 10, b = 20, c = 30;
    int max = a;
    
    if (b > max) max = b;
    if (c > max) max = c;
    
    TEST_ASSERT(max == 30);
    
    int min = a;
    if (b < min) min = b;
    if (c < min) min = c;
    
    TEST_ASSERT(min == 10);
    
    test_printstr("  Conditional chains: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Conditional Selection Tests ===\n");
    
    test_csel();
    test_csinc();
    test_csinv();
    test_csneg();
    test_cset();
    test_cinc();
    test_conditional_chains();
    
    test_printstr("All conditional selection tests passed!\n");
    test_pass();
    return 0;
}
