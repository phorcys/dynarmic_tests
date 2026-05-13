/*
 * Floating Point Compare Test
 * Tests FCMP, FCMPE, FCCMP, FCCMPE instructions
 */

#include "test_syscall.h"

/* Test float comparisons */
static int test_float_cmp(void) {
    test_printstr("Testing float compare...\n");
    
    float a = 1.0f;
    float b = 2.0f;
    float c = 1.0f;
    float neg = -1.0f;
    float zero = 0.0f;
    
    /* Equal */
    TEST_ASSERT(a == c);
    TEST_ASSERT(!(a == b));
    
    /* Not equal */
    TEST_ASSERT(a != b);
    TEST_ASSERT(!(a != c));
    
    /* Less than */
    TEST_ASSERT(a < b);
    TEST_ASSERT(!(b < a));
    TEST_ASSERT(neg < zero);
    
    /* Greater than */
    TEST_ASSERT(b > a);
    TEST_ASSERT(!(a > b));
    TEST_ASSERT(a > neg);
    
    /* Less than or equal */
    TEST_ASSERT(a <= b);
    TEST_ASSERT(a <= c);
    TEST_ASSERT(!(b <= a));
    
    /* Greater than or equal */
    TEST_ASSERT(b >= a);
    TEST_ASSERT(a >= c);
    TEST_ASSERT(!(a >= b));
    
    test_printstr("  Float compare: PASS\n");
    return 0;
}

/* Test double comparisons */
static int test_double_cmp(void) {
    test_printstr("Testing double compare...\n");
    
    double a = 1.0;
    double b = 2.0;
    double c = 1.0;
    
    TEST_ASSERT(a == c);
    TEST_ASSERT(a < b);
    TEST_ASSERT(b > a);
    TEST_ASSERT(a <= c);
    TEST_ASSERT(a >= c);
    
    test_printstr("  Double compare: PASS\n");
    return 0;
}

/* Test NaN comparisons */
static int test_nan_cmp(void) {
    test_printstr("Testing NaN compare...\n");
    
    float nan_val = 0.0f / 0.0f;
    float normal = 1.0f;
    
    /* NaN != NaN */
    TEST_ASSERT(nan_val != nan_val);
    
    /* NaN comparisons are all false except != */
    TEST_ASSERT(!(nan_val < normal));
    TEST_ASSERT(!(nan_val > normal));
    TEST_ASSERT(!(nan_val == normal));
    TEST_ASSERT(!(nan_val == nan_val));
    TEST_ASSERT(nan_val != normal);
    
    /* Normal vs NaN */
    TEST_ASSERT(!(normal == nan_val));
    TEST_ASSERT(!(normal < nan_val));
    TEST_ASSERT(!(normal > nan_val));
    
    test_printstr("  NaN compare: PASS\n");
    return 0;
}

/* Test infinity comparisons */
static int test_inf_cmp(void) {
    test_printstr("Testing infinity compare...\n");
    
    float pos_inf = 1.0f / 0.0f;
    float neg_inf = -1.0f / 0.0f;
    float normal = 1.0f;
    
    /* Positive infinity */
    TEST_ASSERT(pos_inf > normal);
    TEST_ASSERT(pos_inf > neg_inf);
    TEST_ASSERT(!(pos_inf < normal));
    
    /* Negative infinity */
    TEST_ASSERT(neg_inf < normal);
    TEST_ASSERT(neg_inf < pos_inf);
    TEST_ASSERT(!(neg_inf > normal));
    
    /* Infinity equality */
    TEST_ASSERT(pos_inf == pos_inf);
    TEST_ASSERT(neg_inf == neg_inf);
    TEST_ASSERT(pos_inf != neg_inf);
    
    test_printstr("  Infinity compare: PASS\n");
    return 0;
}

/* Test zero sign */
static int test_zero_sign(void) {
    test_printstr("Testing zero sign...\n");
    
    float pos_zero = 0.0f;
    float neg_zero = -0.0f;
    
    /* +0 == -0 */
    TEST_ASSERT(pos_zero == neg_zero);
    
    /* Both are zero */
    TEST_ASSERT(pos_zero == 0.0f);
    TEST_ASSERT(neg_zero == 0.0f);
    
    /* Neither is less than the other */
    TEST_ASSERT(!(pos_zero < neg_zero));
    TEST_ASSERT(!(neg_zero < pos_zero));
    
    test_printstr("  Zero sign: PASS\n");
    return 0;
}

/* Test mixed sign comparisons */
static int test_mixed_sign(void) {
    test_printstr("Testing mixed sign...\n");
    
    float vals[] = { -100.0f, -1.0f, -0.5f, -0.0f, 0.0f, 0.5f, 1.0f, 100.0f };
    int n = 8;
    
    /* Verify ordering */
    for (int i = 0; i < n - 1; i++) {
        TEST_ASSERT(vals[i] < vals[i+1] || vals[i] == vals[i+1]);
        TEST_ASSERT(vals[i+1] > vals[i] || vals[i] == vals[i+1]);
    }
    
    test_printstr("  Mixed sign: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== FP Compare Tests ===\n");
    
    test_float_cmp();
    test_double_cmp();
    test_nan_cmp();
    test_inf_cmp();
    test_zero_sign();
    test_mixed_sign();
    
    test_printstr("All FP compare tests passed!\n");
    test_pass();
    return 0;
}
