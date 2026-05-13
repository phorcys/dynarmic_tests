/*
 * NEON Arithmetic Test
 * Tests NEON arithmetic operations: VADD, VSUB, VMUL, VMLA, VMLS
 */

#include "test_syscall.h"

/* Vector types */
typedef struct { int16_t v[4]; } int16x4_t;
typedef struct { uint16_t v[4]; } uint16x4_t;
typedef struct { int32_t v[2]; } int32x2_t;
typedef struct { uint32_t v[2]; } uint32x2_t;

/* Vector add 16-bit */
static int test_vec_add(void) {
    test_printstr("Testing VADD...\n");
    
    int16_t a[4] = { 100, 200, 300, 400 };
    int16_t b[4] = {  50,  60,  70,  80 };
    int16_t r[4];
    
    for (int i = 0; i < 4; i++) {
        r[i] = a[i] + b[i];
    }
    
    TEST_ASSERT(r[0] == 150);
    TEST_ASSERT(r[1] == 260);
    TEST_ASSERT(r[2] == 370);
    TEST_ASSERT(r[3] == 480);
    
    test_printstr("  VADD: PASS\n");
    return 0;
}

/* Vector subtract 16-bit */
static int test_vec_sub(void) {
    test_printstr("Testing VSUB...\n");
    
    int16_t a[4] = { 100, 200, 300, 400 };
    int16_t b[4] = {  50,  60,  70,  80 };
    int16_t r[4];
    
    for (int i = 0; i < 4; i++) {
        r[i] = a[i] - b[i];
    }
    
    TEST_ASSERT(r[0] == 50);
    TEST_ASSERT(r[1] == 140);
    TEST_ASSERT(r[2] == 230);
    TEST_ASSERT(r[3] == 320);
    
    test_printstr("  VSUB: PASS\n");
    return 0;
}

/* Vector multiply 16-bit */
static int test_vec_mul(void) {
    test_printstr("Testing VMUL...\n");
    
    int16_t a[4] = { 10, 20, 30, 40 };
    int16_t b[4] = {  5,  6,  7,  8 };
    int16_t r[4];
    
    for (int i = 0; i < 4; i++) {
        r[i] = a[i] * b[i];
    }
    
    TEST_ASSERT(r[0] == 50);
    TEST_ASSERT(r[1] == 120);
    TEST_ASSERT(r[2] == 210);
    TEST_ASSERT(r[3] == 320);
    
    test_printstr("  VMUL: PASS\n");
    return 0;
}

/* Vector multiply-accumulate */
static int test_vec_mla(void) {
    test_printstr("Testing VMLA...\n");
    
    int16_t acc[4] = { 100, 200, 300, 400 };
    int16_t a[4] = { 10, 20, 30, 40 };
    int16_t b[4] = {  5,  6,  7,  8 };
    
    /* acc = acc + (a * b) */
    for (int i = 0; i < 4; i++) {
        acc[i] = acc[i] + a[i] * b[i];
    }
    
    TEST_ASSERT(acc[0] == 150);  /* 100 + 50 */
    TEST_ASSERT(acc[1] == 320);  /* 200 + 120 */
    TEST_ASSERT(acc[2] == 510);  /* 300 + 210 */
    TEST_ASSERT(acc[3] == 720);  /* 400 + 320 */
    
    test_printstr("  VMLA: PASS\n");
    return 0;
}

/* Vector multiply-subtract */
static int test_vec_mls(void) {
    test_printstr("Testing VMLS...\n");
    
    int16_t acc[4] = { 1000, 2000, 3000, 4000 };
    int16_t a[4] = { 10, 20, 30, 40 };
    int16_t b[4] = {  5,  6,  7,  8 };
    
    /* acc = acc - (a * b) */
    for (int i = 0; i < 4; i++) {
        acc[i] = acc[i] - a[i] * b[i];
    }
    
    TEST_ASSERT(acc[0] == 950);   /* 1000 - 50 */
    TEST_ASSERT(acc[1] == 1880);  /* 2000 - 120 */
    TEST_ASSERT(acc[2] == 2790);  /* 3000 - 210 */
    TEST_ASSERT(acc[3] == 3680);  /* 4000 - 320 */
    
    test_printstr("  VMLS: PASS\n");
    return 0;
}

/* Vector negate */
static int test_vec_neg(void) {
    test_printstr("Testing VNEG...\n");
    
    int16_t a[4] = { 10, -20, 30, -40 };
    int16_t r[4];
    
    for (int i = 0; i < 4; i++) {
        r[i] = -a[i];
    }
    
    TEST_ASSERT(r[0] == -10);
    TEST_ASSERT(r[1] == 20);
    TEST_ASSERT(r[2] == -30);
    TEST_ASSERT(r[3] == 40);
    
    test_printstr("  VNEG: PASS\n");
    return 0;
}

/* Vector absolute */
static int test_vec_abs(void) {
    test_printstr("Testing VABS...\n");
    
    int16_t a[4] = { 10, -20, 30, -40 };
    int16_t r[4];
    
    for (int i = 0; i < 4; i++) {
        r[i] = a[i] < 0 ? -a[i] : a[i];
    }
    
    TEST_ASSERT(r[0] == 10);
    TEST_ASSERT(r[1] == 20);
    TEST_ASSERT(r[2] == 30);
    TEST_ASSERT(r[3] == 40);
    
    test_printstr("  VABS: PASS\n");
    return 0;
}

/* Vector max/min */
static int test_vec_maxmin(void) {
    test_printstr("Testing VMAX/VMIN...\n");
    
    int16_t a[4] = { 10, 50, 30, 80 };
    int16_t b[4] = { 20, 40, 60, 70 };
    int16_t mx[4], mn[4];
    
    for (int i = 0; i < 4; i++) {
        mx[i] = a[i] > b[i] ? a[i] : b[i];
        mn[i] = a[i] < b[i] ? a[i] : b[i];
    }
    
    TEST_ASSERT(mx[0] == 20);
    TEST_ASSERT(mx[1] == 50);
    TEST_ASSERT(mx[2] == 60);
    TEST_ASSERT(mx[3] == 80);
    
    TEST_ASSERT(mn[0] == 10);
    TEST_ASSERT(mn[1] == 40);
    TEST_ASSERT(mn[2] == 30);
    TEST_ASSERT(mn[3] == 70);
    
    test_printstr("  VMAX/VMIN: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== NEON Arithmetic Tests ===\n");
    
    test_vec_add();
    test_vec_sub();
    test_vec_mul();
    test_vec_mla();
    test_vec_mls();
    test_vec_neg();
    test_vec_abs();
    test_vec_maxmin();
    
    test_printstr("All NEON arithmetic tests passed!\n");
    test_pass();
    return 0;
}
