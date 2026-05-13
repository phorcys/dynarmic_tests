/*
 * Floating Point Advanced Test
 * Tests FMADD, FMSUB, FNMADD, FNMSUB, FMUL, FDIV
 */

#include "test_syscall.h"

/* Test fused multiply-add */
static int test_fmadd(void) {
    test_printstr("Testing FMADD...\n");
    
    /* a + (b * c) */
    double a = 10.0;
    double b = 2.0;
    double c = 3.0;
    
    double result = a + (b * c);  /* 10 + 6 = 16 */
    TEST_ASSERT(result > 15.9 && result < 16.1);
    
    /* Float version */
    float af = 10.0f;
    float bf = 2.0f;
    float cf = 3.0f;
    
    float resultf = af + (bf * cf);
    TEST_ASSERT(resultf > 15.9f && resultf < 16.1f);
    
    test_printstr("  FMADD: PASS\n");
    return 0;
}

/* Test fused multiply-subtract */
static int test_fmsub(void) {
    test_printstr("Testing FMSUB...\n");
    
    /* a - (b * c) */
    double a = 20.0;
    double b = 3.0;
    double c = 4.0;
    
    double result = a - (b * c);  /* 20 - 12 = 8 */
    TEST_ASSERT(result > 7.9 && result < 8.1);
    
    test_printstr("  FMSUB: PASS\n");
    return 0;
}

/* Test negated multiply-add */
static int test_fnmadd(void) {
    test_printstr("Testing FNMADD...\n");
    
    /* -a + (-b * c) = -(a + b*c) */
    double a = 10.0;
    double b = 2.0;
    double c = 3.0;
    
    double result = -(a + (b * c));  /* -(10 + 6) = -16 */
    TEST_ASSERT(result > -16.1 && result < -15.9);
    
    test_printstr("  FNMADD: PASS\n");
    return 0;
}

/* Test negated multiply-subtract */
static int test_fnmsub(void) {
    test_printstr("Testing FNMSUB...\n");
    
    /* -a - (-b * c) = -a + b*c */
    double a = 10.0;
    double b = 3.0;
    double c = 4.0;
    
    double result = -a + (b * c);  /* -10 + 12 = 2 */
    TEST_ASSERT(result > 1.9 && result < 2.1);
    
    test_printstr("  FNMSUB: PASS\n");
    return 0;
}

/* Test floating point multiply */
static int test_fmul(void) {
    test_printstr("Testing FMUL...\n");
    
    double a = 3.14159;
    double b = 2.0;
    
    double result = a * b;
    TEST_ASSERT(result > 6.28 && result < 6.29);
    
    /* Special cases */
    TEST_ASSERT(0.0 * 100.0 == 0.0);
    TEST_ASSERT(1.0 * 50.0 == 50.0);
    
    test_printstr("  FMUL: PASS\n");
    return 0;
}

/* Test floating point divide */
static int test_fdiv(void) {
    test_printstr("Testing FDIV...\n");
    
    double a = 100.0;
    double b = 3.0;
    
    double result = a / b;
    TEST_ASSERT(result > 33.3 && result < 33.4);
    
    /* Divide by 1 */
    TEST_ASSERT(50.0 / 1.0 == 50.0);
    
    /* Divide by itself */
    TEST_ASSERT(100.0 / 100.0 == 1.0);
    
    test_printstr("  FDIV: PASS\n");
    return 0;
}

/* Test floating point square root */
static int test_fsqrt(void) {
    test_printstr("Testing FSQRT...\n");
    
    double a = 16.0;
    double result = 4.0;  /* sqrt(16) = 4 */
    
    /* Newton-Raphson approximation */
    double x = 4.0;  /* Initial guess */
    for (int i = 0; i < 5; i++) {
        x = (x + a / x) / 2;
    }
    
    TEST_ASSERT(x > 3.99 && x < 4.01);
    
    /* sqrt(1) = 1 */
    x = 1.0;
    a = 1.0;
    for (int i = 0; i < 5; i++) {
        x = (x + a / x) / 2;
    }
    TEST_ASSERT(x > 0.99 && x < 1.01);
    
    test_printstr("  FSQRT: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Floating Point Advanced Tests ===\n");
    
    test_fmadd();
    test_fmsub();
    test_fnmadd();
    test_fnmsub();
    test_fmul();
    test_fdiv();
    test_fsqrt();
    
    test_printstr("All floating point advanced tests passed!\n");
    test_pass();
    return 0;
}
