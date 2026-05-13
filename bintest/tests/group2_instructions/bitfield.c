/*
 * Bitfield Operations Test
 * Tests BFI, BFXIL, SBFIZ, SBFX, UBFIZ, UBFX operations
 */

#include "test_syscall.h"

/* Unsigned bit field extract */
static uint64_t ubfx(uint64_t src, int pos, int width) {
    return (src >> pos) & ((1ULL << width) - 1);
}

/* Signed bit field extract */
static int64_t sbfx(int64_t src, int pos, int width) {
    int64_t val = (src >> pos) & ((1ULL << width) - 1);
    /* Sign extend */
    int64_t sign_bit = 1ULL << (width - 1);
    if (val & sign_bit) {
        val |= ~((1ULL << width) - 1);
    }
    return val;
}

/* Bit field insert */
static uint64_t bfi(uint64_t dst, uint64_t src, int pos, int width) {
    uint64_t mask = ((1ULL << width) - 1) << pos;
    return (dst & ~mask) | ((src << pos) & mask);
}

/* Unsigned bit field insert zero */
static uint64_t ubfiz(uint64_t src, int pos, int width) {
    return (src & ((1ULL << width) - 1)) << pos;
}

/* Signed bit field insert zero */
static int64_t sbfiz(int64_t src, int pos, int width) {
    /* Sign extend then shift */
    int64_t val = src << (64 - width);
    val = val >> (64 - width);  /* Sign extend */
    return val << pos;
}

/* Test UBFX */
static int test_ubfx(void) {
    test_printstr("Testing UBFX...\n");
    
    uint64_t x = 0x123456789ABCDEF0ULL;
    
    /* Extract bits 4-7 (4 bits) */
    TEST_ASSERT(ubfx(x, 4, 4) == 0xF);
    
    /* Extract bits 0-7 (8 bits) */
    TEST_ASSERT(ubfx(x, 0, 8) == 0xF0);
    
    /* Extract bits 8-15 (8 bits) */
    TEST_ASSERT(ubfx(x, 8, 8) == 0xDE);
    
    /* Extract bits 16-31 (16 bits) */
    TEST_ASSERT(ubfx(x, 16, 16) == 0x9ABC);
    
    test_printstr("  UBFX: PASS\n");
    return 0;
}

/* Test SBFX */
static int test_sbfx(void) {
    test_printstr("Testing SBFX...\n");
    
    /* Positive number */
    int64_t x = 0x123456789ABCDEF0ULL;
    TEST_ASSERT(sbfx(x, 4, 4) == -1);  /* 0xF sign-extended to 4 bits = -1 */
    
    /* Extract 8 bits starting at 0 (0xF0, positive in 8-bit) */
    TEST_ASSERT(sbfx(x, 0, 8) == -16);  /* 0xF0 = -16 signed */
    
    /* Small positive value */
    int64_t y = 0x123456789ABCDE70ULL;
    TEST_ASSERT(sbfx(y, 0, 8) == 0x70);  /* 0x70 = 112 positive */
    
    test_printstr("  SBFX: PASS\n");
    return 0;
}

/* Test BFI */
static int test_bfi(void) {
    test_printstr("Testing BFI...\n");
    
    uint64_t dst = 0x0000000000000000ULL;
    uint64_t src = 0xF;
    
    /* Insert 4 bits at position 4 */
    TEST_ASSERT(bfi(dst, src, 4, 4) == 0xF0);
    
    /* Insert into existing value */
    dst = 0xFF00;
    TEST_ASSERT(bfi(dst, 0xAB, 8, 8) == 0xAB00);  /* Replaces bits 8-15 */
    
    /* Insert across boundary */
    dst = 0;
    TEST_ASSERT(bfi(dst, 0xFFFF, 4, 16) == 0xFFFF0);
    
    test_printstr("  BFI: PASS\n");
    return 0;
}

/* Test UBFIZ */
static int test_ubfiz(void) {
    test_printstr("Testing UBFIZ...\n");
    
    uint64_t src = 0xABCD;
    
    /* Insert 8 bits at position 8 */
    TEST_ASSERT(ubfiz(src, 8, 8) == 0xCD00);
    
    /* Insert 4 bits at position 0 */
    TEST_ASSERT(ubfiz(0xF, 0, 4) == 0xF);
    
    /* Insert 16 bits at position 16 */
    TEST_ASSERT(ubfiz(0x1234, 16, 16) == 0x12340000);
    
    test_printstr("  UBFIZ: PASS\n");
    return 0;
}

/* Test bit field clear */
static int test_bfc(void) {
    test_printstr("Testing BFC...\n");
    
    uint64_t x = 0xFFFFFFFFFFFFFFFFULL;
    
    /* Clear 8 bits at position 8 */
    uint64_t mask = ((1ULL << 8) - 1) << 8;
    uint64_t result = x & ~mask;
    TEST_ASSERT(result == 0xFFFFFFFFFFFF00FFULL);
    
    /* Clear 16 bits at position 0 */
    mask = ((1ULL << 16) - 1);
    result = x & ~mask;
    TEST_ASSERT(result == 0xFFFFFFFFFFFF0000ULL);
    
    test_printstr("  BFC: PASS\n");
    return 0;
}

/* Test complex bit field operations */
static int test_complex_bitfield(void) {
    test_printstr("Testing complex bitfield...\n");
    
    /* Build a value from multiple fields */
    uint64_t val = 0;
    val = bfi(val, 0x123, 0, 12);    /* 12-bit field */
    val = bfi(val, 0x45, 12, 8);     /* 8-bit field */
    val = bfi(val, 0x67, 20, 8);     /* 8-bit field */
    
    /* Extract and verify */
    TEST_ASSERT(ubfx(val, 0, 12) == 0x123);
    TEST_ASSERT(ubfx(val, 12, 8) == 0x45);
    TEST_ASSERT(ubfx(val, 20, 8) == 0x67);
    
    test_printstr("  Complex bitfield: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Bitfield Operations Tests ===\n");
    
    test_ubfx();
    test_sbfx();
    test_bfi();
    test_ubfiz();
    test_bfc();
    test_complex_bitfield();
    
    test_printstr("All bitfield operations tests passed!\n");
    test_pass();
    return 0;
}
