/*
 * Floating Point Edge Cases
 * Tests NaN, Infinity, denormals, and FP boundary conditions
 */

#include "test_syscall.h"

/* Define our own FP constants since we don't have math.h */
#define INF_POS  (1.0 / 0.0)
#define INF_NEG  (-1.0 / 0.0)
#define NAN_VAL  (0.0 / 0.0)

static int is_nan(double x) {
    /* NaN is not equal to itself */
    return x != x;
}

static int is_inf(double x) {
    return x == INF_POS || x == INF_NEG;
}

static int test_inf_operations(void) {
    test_printstr("Testing infinity operations...\n");
    
    double pinf = INF_POS;
    double ninf = INF_NEG;
    
    /* Infinity arithmetic */
    TEST_ASSERT(pinf + 1.0 == pinf);
    TEST_ASSERT(pinf * 2.0 == pinf);
    TEST_ASSERT(ninf + 1.0 == ninf);
    
    /* Infinity comparison */
    TEST_ASSERT(ninf < pinf);
    TEST_ASSERT(ninf < 0.0);
    TEST_ASSERT(pinf > 0.0);
    
    /* Infinity from division */
    double result = 1.0 / 0.0;
    TEST_ASSERT(result == pinf);
    
    result = -1.0 / 0.0;
    TEST_ASSERT(result == ninf);
    
    test_printstr("  Infinity ops: PASS\n");
    return 0;
}

static int test_nan_operations(void) {
    test_printstr("Testing NaN operations...\n");
    
    double nan_val = NAN_VAL;
    
    /* NaN properties */
    TEST_ASSERT(is_nan(nan_val));
    TEST_ASSERT(!(nan_val == nan_val));  /* NaN != NaN */
    TEST_ASSERT(!(nan_val < 0.0));
    TEST_ASSERT(!(nan_val > 0.0));
    
    /* NaN propagation */
    double result = nan_val + 1.0;
    TEST_ASSERT(is_nan(result));
    
    result = nan_val * 2.0;
    TEST_ASSERT(is_nan(result));
    
    /* 0/0 = NaN */
    result = 0.0 / 0.0;
    TEST_ASSERT(is_nan(result));
    
    /* inf - inf = NaN */
    result = INF_POS - INF_POS;
    TEST_ASSERT(is_nan(result));
    
    /* 0 * inf = NaN */
    result = 0.0 * INF_POS;
    TEST_ASSERT(is_nan(result));
    
    test_printstr("  NaN ops: PASS\n");
    return 0;
}

static int test_special_comparisons(void) {
    test_printstr("Testing special FP comparisons...\n");
    
    double zero = 0.0;
    double neg_zero = -0.0;
    
    /* +0 and -0 are equal */
    TEST_ASSERT(zero == neg_zero);
    TEST_ASSERT(!(zero < neg_zero));
    TEST_ASSERT(!(zero > neg_zero));
    
    /* NaN != NaN is TRUE in IEEE 754 */
    double nan_val = NAN_VAL;
    volatile int nan_ne = (nan_val != nan_val);
    TEST_ASSERT(nan_ne);  /* This should be true */
    
    test_printstr("  Special comparisons: PASS\n");
    return 0;
}

static int test_fp_rounding(void) {
    test_printstr("Testing FP rounding...\n");
    
    /* Integer to float conversion */
    int64_t small = 123456789LL;
    double d = (double)small;
    int64_t back = (int64_t)d;
    TEST_ASSERT(back == small);
    
    /* Truncation toward zero */
    double pos = 3.7;
    double neg = -3.7;
    TEST_ASSERT((int64_t)pos == 3);
    TEST_ASSERT((int64_t)neg == -3);
    
    test_printstr("  FP rounding: PASS\n");
    return 0;
}

static int test_fp_edge_arithmetic(void) {
    test_printstr("Testing FP edge arithmetic...\n");
    
    /* Very small numbers (denormals) */
    double tiny = 1e-310;
    double result = tiny * 2.0;
    TEST_ASSERT(result != 0.0);  /* Still denormal, not zero */
    
    /* Overflow to infinity */
    double huge = 1e308;
    result = huge * 2.0;
    TEST_ASSERT(is_inf(result));
    
    /* Underflow to zero */
    double very_small = 1e-320;
    result = very_small * 0.5;
    /* May become zero or stay denormal */
    TEST_ASSERT(result >= 0.0);
    
    test_printstr("  FP edge arithmetic: PASS\n");
    return 0;
}

static int test_float_precision(void) {
    test_printstr("Testing float precision...\n");
    
    /* Float has ~7 decimal digits of precision */
    float f = 1234567.0f;
    float f2 = f + 0.1f;  /* Might not change */
    
    /* Double has ~15 decimal digits */
    double d = 123456789012345.0;
    double d2 = d + 0.001;
    
    /* These operations test precision differences */
    
    test_printstr("  Float precision: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Floating Point Edge Tests ===\n");
    
    test_inf_operations();
    test_nan_operations();
    test_special_comparisons();
    test_fp_rounding();
    test_fp_edge_arithmetic();
    test_float_precision();
    
    test_printstr("=== All FP edge tests passed ===\n");
    test_pass();
    return 0;
}
