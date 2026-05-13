/*
 * Register Pressure Test
 * Tests register allocation under pressure
 */

#include "test_syscall.h"

/* Function with many live values */
static int64_t many_live_values(void) {
    volatile int64_t a = 1, b = 2, c = 3, d = 4;
    volatile int64_t e = 5, f = 6, g = 7, h = 8;
    volatile int64_t i = 9, j = 10, k = 11, l = 12;
    volatile int64_t m = 13, n = 14, o = 15, p = 16;
    volatile int64_t q = 17, r = 18, s = 19, t = 20;
    volatile int64_t u = 21, v = 22, w = 23, x = 24;
    
    /* Use all values to keep them live */
    return a + b + c + d + e + f + g + h + 
           i + j + k + l + m + n + o + p +
           q + r + s + t + u + v + w + x;
}

/* Function with many parameters */
static int64_t sum_8_params(int64_t a, int64_t b, int64_t c, int64_t d,
                           int64_t e, int64_t f, int64_t g, int64_t h) {
    return a + b + c + d + e + f + g + h;
}

/* Function with many locals and complex expressions */
static int64_t complex_expr(void) {
    volatile int64_t a = 100, b = 50, c = 25, d = 12;
    volatile int64_t e = 6, f = 3, g = 1, h = 0;
    
    /* Complex expressions to stress register allocation */
    int64_t r1 = a * b + c * d;
    int64_t r2 = e * f - g * h;
    int64_t r3 = (a + b) * (c - d);
    int64_t r4 = (e - f) * (g + h);
    
    return r1 + r2 + r3 + r4;
}

/* Nested calls with many arguments */
static int64_t inner(int64_t x, int64_t y) {
    return x * y;
}

static int64_t middle(int64_t a, int64_t b, int64_t c, int64_t d) {
    return inner(a, b) + inner(c, d);
}

static int64_t outer(int64_t a, int64_t b, int64_t c, int64_t d,
                     int64_t e, int64_t f, int64_t g, int64_t h) {
    return middle(a, b, c, d) + middle(e, f, g, h);
}

/* Test many live values */
static int test_many_live(void) {
    test_printstr("Testing many live values...\n");
    
    int64_t sum = many_live_values();
    TEST_ASSERT(sum == 300);  /* 1+2+...+24 = 300 */
    
    test_printstr("  Many live values: PASS\n");
    return 0;
}

/* Test many parameters */
static int test_many_params(void) {
    test_printstr("Testing many params...\n");
    
    int64_t sum = sum_8_params(1, 2, 3, 4, 5, 6, 7, 8);
    TEST_ASSERT(sum == 36);
    
    sum = sum_8_params(10, 20, 30, 40, 50, 60, 70, 80);
    TEST_ASSERT(sum == 360);
    
    test_printstr("  Many params: PASS\n");
    return 0;
}

/* Test complex expressions */
static int test_complex_expr(void) {
    test_printstr("Testing complex expr...\n");
    
    int64_t result = complex_expr();
    /* r1 = 100*50 + 25*12 = 5000 + 300 = 5300
       r2 = 6*3 - 1*0 = 18
       r3 = 150 * 13 = 1950
       r4 = 3 * 1 = 3
       total = 5300 + 18 + 1950 + 3 = 7271
    */
    TEST_ASSERT(result == 7271);
    
    test_printstr("  Complex expr: PASS\n");
    return 0;
}

/* Test nested calls */
static int test_nested_calls(void) {
    test_printstr("Testing nested calls...\n");
    
    int64_t result = outer(1, 2, 3, 4, 5, 6, 7, 8);
    /* inner(1,2)=2, inner(3,4)=12, inner(5,6)=30, inner(7,8)=56
       middle(1,2,3,4) = 2 + 12 = 14
       middle(5,6,7,8) = 30 + 56 = 86
       outer = 14 + 86 = 100
    */
    TEST_ASSERT(result == 100);
    
    test_printstr("  Nested calls: PASS\n");
    return 0;
}

/* Test register pressure in loops */
static int test_loop_pressure(void) {
    test_printstr("Testing loop pressure...\n");
    
    volatile int64_t a = 1, b = 2, c = 3, d = 4;
    int64_t sum = 0;
    
    for (int i = 0; i < 10; i++) {
        sum += a * i + b * i + c * i + d * i;
    }
    /* sum = (1+2+3+4) * (0+1+...+9) = 10 * 45 = 450 */
    TEST_ASSERT(sum == 450);
    
    test_printstr("  Loop pressure: PASS\n");
    return 0;
}

/* Test self-modifying pattern (same reg as source and dest) */
static int test_self_modify(void) {
    test_printstr("Testing self modify...\n");
    
    int64_t x = 10;
    x = x + 1;
    x = x * 2;
    x = x - 5;
    x = x / 3;
    TEST_ASSERT(x == 5);  /* ((10+1)*2-5)/3 = 17/3 = 5 */
    
    int64_t y = 100;
    y += y;   /* 200 */
    y -= y;   /* 0 */
    TEST_ASSERT(y == 0);
    
    test_printstr("  Self modify: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Register Pressure Tests ===\n");
    
    test_many_live();
    test_many_params();
    test_complex_expr();
    test_nested_calls();
    test_loop_pressure();
    test_self_modify();
    
    test_printstr("All register pressure tests passed!\n");
    test_pass();
    return 0;
}
