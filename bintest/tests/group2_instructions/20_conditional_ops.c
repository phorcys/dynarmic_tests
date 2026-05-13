/*
 * Conditional Instruction Tests
 * Tests CSEL, CSINC, CSET, CCMP and related conditional operations
 */

#include "test_syscall.h"

/* Test CSEL - conditional select */
static int test_csel(void) {
    test_printstr("Testing CSEL...\n");
    
    int64_t a = 10, b = 20, c = 30, d = 40;
    int64_t result;
    
    /* Conditional select based on comparison */
    if (a < b) {
        result = c;
    } else {
        result = d;
    }
    TEST_ASSERT(result == 30);
    
    if (a > b) {
        result = c;
    } else {
        result = d;
    }
    TEST_ASSERT(result == 40);
    
    /* Nested conditional */
    int64_t x = 5;
    if (x > 0) {
        if (x < 10) {
            result = 100;
        } else {
            result = 200;
        }
    } else {
        result = 300;
    }
    TEST_ASSERT(result == 100);
    
    test_printstr("  CSEL: PASS\n");
    return 0;
}

/* Test conditional increment/decrement */
static int test_cond_inc_dec(void) {
    test_printstr("Testing conditional inc/dec...\n");
    
    int64_t val = 100;
    
    /* Conditional increment */
    int64_t cond = 1;
    if (cond) {
        val++;
    }
    TEST_ASSERT(val == 101);
    
    /* Conditional decrement */
    cond = 0;
    if (cond) {
        val--;
    }
    TEST_ASSERT(val == 101);  /* Unchanged */
    
    /* Conditional add */
    val = cond ? val + 50 : val + 10;
    TEST_ASSERT(val == 111);
    
    test_printstr("  Conditional inc/dec: PASS\n");
    return 0;
}

/* Test ternary operator chains */
static int test_ternary_chain(void) {
    test_printstr("Testing ternary chains...\n");
    
    int64_t val = 5;
    
    /* Simple ternary */
    int64_t result = (val > 0) ? 1 : -1;
    TEST_ASSERT(result == 1);
    
    /* Nested ternary */
    result = (val < 0) ? -1 : (val > 10) ? 2 : 0;
    TEST_ASSERT(result == 0);
    
    /* Complex ternary */
    result = (val == 0) ? 0 : (val < 0) ? -val : val * 2;
    TEST_ASSERT(result == 10);
    
    test_printstr("  Ternary chains: PASS\n");
    return 0;
}

/* Test conditional assignment patterns */
static int test_cond_assign(void) {
    test_printstr("Testing conditional assignment...\n");
    
    int64_t a = 0;
    int64_t b = 0;
    
    /* Set based on multiple conditions */
    for (int64_t i = -2; i <= 2; i++) {
        if (i < 0) {
            a = -1;
        } else if (i == 0) {
            a = 0;
        } else {
            a = 1;
        }
        b += a;
    }
    TEST_ASSERT(b == -1 + -1 + 0 + 1 + 1);  /* = 0 */
    
    test_printstr("  Conditional assignment: PASS\n");
    return 0;
}

/* Test conditional with complex expressions */
static int test_cond_complex(void) {
    test_printstr("Testing complex conditional expressions...\n");
    
    int64_t a = 10, b = 20, c = 5;
    
    /* Compound conditions */
    int64_t result = (a < b && b > c) ? 100 : 0;
    TEST_ASSERT(result == 100);
    
    result = (a > b || c < a) ? 200 : 0;
    TEST_ASSERT(result == 200);
    
    result = (!(a > b)) ? 300 : 0;
    TEST_ASSERT(result == 300);
    
    /* XOR-like condition */
    result = ((a > 0) != (b < 0)) ? 400 : 0;
    TEST_ASSERT(result == 400);
    
    test_printstr("  Complex conditional: PASS\n");
    return 0;
}

/* Test branch patterns */
static int test_branch_patterns(void) {
    test_printstr("Testing branch patterns...\n");
    
    int64_t sum;
    
    /* Early exit pattern */
    sum = 0;
    for (int64_t i = 0; i < 10; i++) {
        sum += i;
    }
    TEST_ASSERT(sum == 45);
    
    /* Skip even numbers */
    sum = 0;
    for (int64_t i = 0; i < 10; i++) {
        if (i & 1) sum += i;  /* Only odd numbers */
    }
    TEST_ASSERT(sum == 25);  /* 1+3+5+7+9 = 25 */
    
    test_printstr("  Branch patterns: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Conditional Instruction Tests ===\n");
    
    test_csel();
    test_cond_inc_dec();
    test_ternary_chain();
    test_cond_assign();
    test_cond_complex();
    test_branch_patterns();
    
    test_printstr("=== All conditional tests passed ===\n");
    test_pass();
    return 0;
}
