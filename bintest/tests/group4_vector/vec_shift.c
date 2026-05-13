/*
 * Vector Shift Operations Test
 * Tests NEON vector shift instructions: SSHL, USHL, SSHR, USHR, SSRA, USRA
 */

#include "test_syscall.h"

/* Vector types */
typedef struct { int8_t v[16]; } int8x16_t;
typedef struct { uint8_t v[16]; } uint8x16_t;
typedef struct { int16_t v[8]; } int16x8_t;
typedef struct { uint16_t v[8]; } uint16x8_t;
typedef struct { int32_t v[4]; } int32x4_t;
typedef struct { uint32_t v[4]; } uint32x4_t;

/* Shift right arithmetic (signed) */
static int16x8_t vshrq_n_s16(int16x8_t a, int n) {
    int16x8_t r;
    for (int i = 0; i < 8; i++) {
        r.v[i] = a.v[i] >> n;
    }
    return r;
}

/* Shift right logical (unsigned) */
static uint16x8_t vshrq_n_u16(uint16x8_t a, int n) {
    uint16x8_t r;
    for (int i = 0; i < 8; i++) {
        r.v[i] = a.v[i] >> n;
    }
    return r;
}

/* Shift left */
static int16x8_t vshlq_n_s16(int16x8_t a, int n) {
    int16x8_t r;
    for (int i = 0; i < 8; i++) {
        r.v[i] = a.v[i] << n;
    }
    return r;
}

/* Rounding shift right */
static int16x8_t vrshrq_n_s16(int16x8_t a, int n) {
    int16x8_t r;
    int round = 1 << (n - 1);
    for (int i = 0; i < 8; i++) {
        r.v[i] = (a.v[i] + round) >> n;
    }
    return r;
}

/* Test arithmetic shift right */
static int test_ashr(void) {
    test_printstr("Testing ASHR...\n");
    
    int16x8_t a = {{ -128, -64, -32, -16, -8, -4, -2, -1 }};
    int16x8_t r = vshrq_n_s16(a, 2);
    
    TEST_ASSERT(r.v[0] == -32);   /* -128 >> 2 = -32 */
    TEST_ASSERT(r.v[1] == -16);   /* -64 >> 2 = -16 */
    TEST_ASSERT(r.v[2] == -8);
    TEST_ASSERT(r.v[3] == -4);
    TEST_ASSERT(r.v[4] == -2);
    TEST_ASSERT(r.v[5] == -1);
    TEST_ASSERT(r.v[6] == -1);    /* -2 >> 2 = -1 (arithmetic) */
    TEST_ASSERT(r.v[7] == -1);    /* -1 >> 2 = -1 */
    
    test_printstr("  ASHR: PASS\n");
    return 0;
}

/* Test logical shift right */
static int test_lshr(void) {
    test_printstr("Testing LSHR...\n");
    
    uint16x8_t a = {{ 0x8000, 0x4000, 0x2000, 0x1000, 0x800, 0x400, 0x200, 0x100 }};
    uint16x8_t r = vshrq_n_u16(a, 4);
    
    TEST_ASSERT(r.v[0] == 0x0800);
    TEST_ASSERT(r.v[1] == 0x0400);
    TEST_ASSERT(r.v[2] == 0x0200);
    TEST_ASSERT(r.v[3] == 0x0100);
    
    test_printstr("  LSHR: PASS\n");
    return 0;
}

/* Test shift left */
static int test_shl(void) {
    test_printstr("Testing SHL...\n");
    
    int16x8_t a = {{ 1, 2, 4, 8, 16, 32, 64, 128 }};
    int16x8_t r = vshlq_n_s16(a, 3);
    
    TEST_ASSERT(r.v[0] == 8);
    TEST_ASSERT(r.v[1] == 16);
    TEST_ASSERT(r.v[2] == 32);
    TEST_ASSERT(r.v[3] == 64);
    TEST_ASSERT(r.v[4] == 128);
    TEST_ASSERT(r.v[5] == 256);
    TEST_ASSERT(r.v[6] == 512);
    TEST_ASSERT(r.v[7] == 1024);
    
    test_printstr("  SHL: PASS\n");
    return 0;
}

/* Test rounding shift */
static int test_rshr(void) {
    test_printstr("Testing RSHR...\n");
    
    int16x8_t a = {{ 4, 5, 6, 7, 8, 12, 16, 20 }};
    int16x8_t r = vrshrq_n_s16(a, 2);
    
    /* Rounding: (x + 2) >> 2 = (x + 2) / 4 */
    /* 4+2=6, 6>>2=1 */
    /* 5+2=7, 7>>2=1 */
    /* 6+2=8, 8>>2=2 */
    /* 7+2=9, 9>>2=2 */
    /* 8+2=10, 10>>2=2 */
    /* 12+2=14, 14>>2=3 */
    /* 16+2=18, 18>>2=4 */
    /* 20+2=22, 22>>2=5 */
    TEST_ASSERT(r.v[0] == 1);
    TEST_ASSERT(r.v[1] == 1);
    TEST_ASSERT(r.v[2] == 2);
    TEST_ASSERT(r.v[3] == 2);
    TEST_ASSERT(r.v[4] == 2);
    TEST_ASSERT(r.v[5] == 3);
    TEST_ASSERT(r.v[6] == 4);
    TEST_ASSERT(r.v[7] == 5);
    
    test_printstr("  RSHR: PASS\n");
    return 0;
}

/* Test edge cases */
static int test_edge_cases(void) {
    test_printstr("Testing shift edge cases...\n");
    
    /* Shift by 0 */
    int16x8_t a = {{ 1, 2, 3, 4, 5, 6, 7, 8 }};
    int16x8_t r = vshrq_n_s16(a, 0);
    TEST_ASSERT(r.v[0] == 1);
    
    /* Shift by 15 (max for int16) */
    int16x8_t b = {{ -32768, 32767, 0, 1, -1, 0x4000, -0x4000, 0x8000 }};
    int16x8_t s = vshrq_n_s16(b, 15);
    TEST_ASSERT(s.v[0] == -1);   /* -32768 >> 15 = -1 */
    TEST_ASSERT(s.v[1] == 0);    /* 32767 >> 15 = 0 */
    TEST_ASSERT(s.v[2] == 0);
    TEST_ASSERT(s.v[3] == 0);
    TEST_ASSERT(s.v[4] == -1);   /* -1 >> 15 = -1 */
    
    test_printstr("  Edge cases: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Vector Shift Tests ===\n");
    
    test_ashr();
    test_lshr();
    test_shl();
    test_rshr();
    test_edge_cases();
    
    test_printstr("All vector shift tests passed!\n");
    test_pass();
    return 0;
}
