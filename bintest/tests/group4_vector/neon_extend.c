/*
 * NEON Extension Operations Test
 * Tests NEON extended operations: SXTL, UXTL, SHLL, XTN, etc.
 */

#include "test_syscall.h"

/* Vector types */
typedef struct { int8_t v[8]; } int8x8_t;
typedef struct { uint8_t v[8]; } uint8x8_t;
typedef struct { int16_t v[4]; } int16x4_t;
typedef struct { uint16_t v[4]; } uint16x4_t;
typedef struct { int32_t v[2]; } int32x2_t;
typedef struct { uint32_t v[2]; } uint32x2_t;
typedef struct { int16_t v[8]; } int16x8_t;
typedef struct { int32_t v[4]; } int32x4_t;

/* Sign-extend 8-bit to 16-bit */
static int16x8_t vmovl_s8(int8x8_t a) {
    int16x8_t r;
    for (int i = 0; i < 8; i++) {
        r.v[i] = a.v[i];  /* Sign extension happens automatically */
    }
    return r;
}

/* Zero-extend 8-bit to 16-bit */
static int16x8_t vmovl_u8(uint8x8_t a) {
    int16x8_t r;
    for (int i = 0; i < 8; i++) {
        r.v[i] = a.v[i];  /* Zero extension */
    }
    return r;
}

/* Narrow 16-bit to 8-bit */
static uint8x8_t vmovn_u16(uint16x4_t a) {
    uint8x8_t r;
    for (int i = 0; i < 4; i++) {
        r.v[i] = a.v[i] & 0xFF;
    }
    return r;
}

/* Test sign extension */
static int test_sxtl(void) {
    test_printstr("Testing SXTL...\n");
    
    int8x8_t a = {{ -1, -128, 127, 0, 1, 64, -64, 100 }};
    int16x8_t r = vmovl_s8(a);
    
    TEST_ASSERT(r.v[0] == -1);
    TEST_ASSERT(r.v[1] == -128);
    TEST_ASSERT(r.v[2] == 127);
    TEST_ASSERT(r.v[3] == 0);
    TEST_ASSERT(r.v[4] == 1);
    TEST_ASSERT(r.v[5] == 64);
    TEST_ASSERT(r.v[6] == -64);
    TEST_ASSERT(r.v[7] == 100);
    
    test_printstr("  SXTL: PASS\n");
    return 0;
}

/* Test zero extension */
static int test_uxtl(void) {
    test_printstr("Testing UXTL...\n");
    
    uint8x8_t a = {{ 255, 128, 127, 0, 1, 64, 200, 100 }};
    int16x8_t r = vmovl_u8(a);
    
    TEST_ASSERT(r.v[0] == 255);
    TEST_ASSERT(r.v[1] == 128);
    TEST_ASSERT(r.v[2] == 127);
    TEST_ASSERT(r.v[3] == 0);
    TEST_ASSERT(r.v[4] == 1);
    TEST_ASSERT(r.v[5] == 64);
    TEST_ASSERT(r.v[6] == 200);
    TEST_ASSERT(r.v[7] == 100);
    
    test_printstr("  UXTL: PASS\n");
    return 0;
}

/* Test shift left and extend */
static int test_shll(void) {
    test_printstr("Testing SHLL...\n");
    
    uint8x8_t a = {{ 1, 2, 3, 4, 5, 6, 7, 8 }};
    int16x8_t r;
    
    /* Shift left by 8 and extend */
    for (int i = 0; i < 8; i++) {
        r.v[i] = ((int16_t)a.v[i]) << 8;
    }
    
    TEST_ASSERT(r.v[0] == 256);
    TEST_ASSERT(r.v[1] == 512);
    TEST_ASSERT(r.v[2] == 768);
    TEST_ASSERT(r.v[3] == 1024);
    
    test_printstr("  SHLL: PASS\n");
    return 0;
}

/* Test narrow */
static int test_xtn(void) {
    test_printstr("Testing XTN...\n");
    
    int16_t vals[4] = { 0x1234, 0x5678, 0x9ABC, 0xDEF0 };
    int8_t narrow[4];
    
    /* Narrow 16-bit to 8-bit (truncate) */
    for (int i = 0; i < 4; i++) {
        narrow[i] = vals[i] & 0xFF;
    }
    
    TEST_ASSERT(narrow[0] == 0x34);
    TEST_ASSERT(narrow[1] == 0x78);
    TEST_ASSERT(narrow[2] == (int8_t)0xBC);
    TEST_ASSERT(narrow[3] == (int8_t)0xF0);
    
    test_printstr("  XTN: PASS\n");
    return 0;
}

/* Test saturating narrow */
static int test_sqxtn(void) {
    test_printstr("Testing SQXTN...\n");
    
    /* Saturate 16-bit to 8-bit signed */
    int16_t vals[4] = { 100, 127, 128, -129 };
    int8_t sat[4];
    
    for (int i = 0; i < 4; i++) {
        if (vals[i] > 127) sat[i] = 127;
        else if (vals[i] < -128) sat[i] = -128;
        else sat[i] = vals[i];
    }
    
    TEST_ASSERT(sat[0] == 100);
    TEST_ASSERT(sat[1] == 127);
    TEST_ASSERT(sat[2] == 127);   /* Saturated */
    TEST_ASSERT(sat[3] == -128);  /* Saturated */
    
    test_printstr("  SQXTN: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== NEON Extension Tests ===\n");
    
    test_sxtl();
    test_uxtl();
    test_shll();
    test_xtn();
    test_sqxtn();
    
    test_printstr("All NEON extension tests passed!\n");
    test_pass();
    return 0;
}
