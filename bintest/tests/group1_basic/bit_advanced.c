/*
 * Bit Manipulation Advanced Test
 * Tests advanced bit operations
 */

#include "test_syscall.h"

/* Count trailing zeros (software implementation) */
static int ctz32(uint32_t x) {
    if (x == 0) return 32;
    int n = 0;
    while ((x & 1) == 0) {
        n++;
        x >>= 1;
    }
    return n;
}

/* Count leading zeros (software implementation) */
static int clz32(uint32_t x) {
    if (x == 0) return 32;
    int n = 0;
    uint32_t mask = 0x80000000;
    while ((x & mask) == 0) {
        n++;
        mask >>= 1;
    }
    return n;
}

/* Population count */
static int popcount32(uint32_t x) {
    int count = 0;
    while (x) {
        count += x & 1;
        x >>= 1;
    }
    return count;
}

/* Reverse bits */
static uint32_t reverse32(uint32_t x) {
    uint32_t r = 0;
    for (int i = 0; i < 32; i++) {
        r = (r << 1) | (x & 1);
        x >>= 1;
    }
    return r;
}

/* Byte swap */
static uint32_t bswap32(uint32_t x) {
    return ((x >> 24) & 0xFF) |
           ((x >> 8) & 0xFF00) |
           ((x << 8) & 0xFF0000) |
           ((x << 24) & 0xFF000000);
}

/* Parity */
static int parity32(uint32_t x) {
    return popcount32(x) & 1;
}

/* Test CTZ */
static int test_ctz(void) {
    test_printstr("Testing CTZ...\n");
    
    TEST_ASSERT(ctz32(1) == 0);
    TEST_ASSERT(ctz32(2) == 1);
    TEST_ASSERT(ctz32(4) == 2);
    TEST_ASSERT(ctz32(8) == 3);
    TEST_ASSERT(ctz32(16) == 4);
    TEST_ASSERT(ctz32(0x80000000) == 31);
    
    test_printstr("  CTZ: PASS\n");
    return 0;
}

/* Test CLZ */
static int test_clz(void) {
    test_printstr("Testing CLZ...\n");
    
    TEST_ASSERT(clz32(0x80000000) == 0);
    TEST_ASSERT(clz32(0x40000000) == 1);
    TEST_ASSERT(clz32(0x20000000) == 2);
    TEST_ASSERT(clz32(1) == 31);
    TEST_ASSERT(clz32(0x8000) == 16);
    
    test_printstr("  CLZ: PASS\n");
    return 0;
}

/* Test popcount */
static int test_popcount(void) {
    test_printstr("Testing popcount...\n");
    
    TEST_ASSERT(popcount32(0) == 0);
    TEST_ASSERT(popcount32(1) == 1);
    TEST_ASSERT(popcount32(0xFFFFFFFF) == 32);
    TEST_ASSERT(popcount32(0xAAAAAAAA) == 16);
    TEST_ASSERT(popcount32(0x55555555) == 16);
    
    test_printstr("  Popcount: PASS\n");
    return 0;
}

/* Test reverse */
static int test_reverse(void) {
    test_printstr("Testing reverse...\n");
    
    TEST_ASSERT(reverse32(0) == 0);
    TEST_ASSERT(reverse32(0xFFFFFFFF) == 0xFFFFFFFF);
    TEST_ASSERT(reverse32(1) == 0x80000000);
    TEST_ASSERT(reverse32(0x80000000) == 1);
    TEST_ASSERT(reverse32(0x12345678) == 0x1E6A2C48);
    
    test_printstr("  Reverse: PASS\n");
    return 0;
}

/* Test byte swap */
static int test_bswap(void) {
    test_printstr("Testing bswap...\n");
    
    TEST_ASSERT(bswap32(0x12345678) == 0x78563412);
    TEST_ASSERT(bswap32(0x00000001) == 0x01000000);
    TEST_ASSERT(bswap32(0x01000000) == 0x00000001);
    TEST_ASSERT(bswap32(0xFFFFFFFF) == 0xFFFFFFFF);
    
    test_printstr("  Bswap: PASS\n");
    return 0;
}

/* Test parity */
static int test_parity(void) {
    test_printstr("Testing parity...\n");
    
    TEST_ASSERT(parity32(0) == 0);        /* Even parity */
    TEST_ASSERT(parity32(1) == 1);        /* Odd parity */
    TEST_ASSERT(parity32(3) == 0);        /* Even parity (2 bits) */
    TEST_ASSERT(parity32(0x55) == 0);     /* 4 bits set, even */
    
    test_printstr("  Parity: PASS\n");
    return 0;
}

/* Test bit field operations */
static int test_bitfield(void) {
    test_printstr("Testing bitfield...\n");
    
    /* Extract */
    uint32_t x = 0x12345678;
    uint32_t low8 = x & 0xFF;
    uint32_t high8 = (x >> 24) & 0xFF;
    
    TEST_ASSERT(low8 == 0x78);
    TEST_ASSERT(high8 == 0x12);
    
    /* Insert */
    uint32_t y = 0;
    y |= (0x12 << 24);
    y |= (0x34 << 16);
    y |= (0x56 << 8);
    y |= 0x78;
    TEST_ASSERT(y == 0x12345678);
    
    test_printstr("  Bitfield: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Bit Manipulation Advanced Tests ===\n");
    
    test_ctz();
    test_clz();
    test_popcount();
    test_reverse();
    test_bswap();
    test_parity();
    test_bitfield();
    
    test_printstr("All bit manipulation advanced tests passed!\n");
    test_pass();
    return 0;
}
