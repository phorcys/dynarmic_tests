/*
 * Rotate and Bit Insert Test
 * Tests ROR, EXTR, RBIT operations
 */

#include "test_syscall.h"

/* Rotate right */
static uint64_t ror64(uint64_t x, int n) {
    n &= 63;
    return (x >> n) | (x << (64 - n));
}

/* Rotate left */
static uint64_t rol64(uint64_t x, int n) {
    n &= 63;
    return (x << n) | (x >> (64 - n));
}

/* Extract register */
static uint64_t extr64(uint64_t hi, uint64_t lo, int pos) {
    return (hi << (64 - pos)) | (lo >> pos);
}

/* Reverse bits */
static uint64_t rbit64(uint64_t x) {
    uint64_t r = 0;
    for (int i = 0; i < 64; i++) {
        r = (r << 1) | (x & 1);
        x >>= 1;
    }
    return r;
}

/* Reverse bytes */
static uint64_t rev64(uint64_t x) {
    uint64_t r = 0;
    for (int i = 0; i < 8; i++) {
        r = (r << 8) | (x & 0xFF);
        x >>= 8;
    }
    return r;
}

/* Test rotate right */
static int test_ror(void) {
    test_printstr("Testing ROR...\n");
    
    uint64_t x = 0x8000000000000001ULL;
    
    /* Rotate right by 1 */
    TEST_ASSERT(ror64(x, 1) == 0xC000000000000000ULL);
    
    /* Rotate right by 63 */
    TEST_ASSERT(ror64(x, 63) == 0x0000000000000003ULL);
    
    /* Rotate by 64 (no change) */
    TEST_ASSERT(ror64(x, 64) == x);
    
    test_printstr("  ROR: PASS\n");
    return 0;
}

/* Test rotate left */
static int test_rol(void) {
    test_printstr("Testing ROL...\n");
    
    uint64_t x = 0x8000000000000001ULL;
    
    /* Rotate left by 1 */
    TEST_ASSERT(rol64(x, 1) == 0x0000000000000003ULL);
    
    /* Rotate left by 63 */
    TEST_ASSERT(rol64(x, 63) == 0xC000000000000000ULL);
    
    test_printstr("  ROL: PASS\n");
    return 0;
}

/* Test extract register */
static int test_extr(void) {
    test_printstr("Testing EXTR...\n");
    
    uint64_t hi = 0x123456789ABCDEF0ULL;
    uint64_t lo = 0xFEDCBA9876543210ULL;
    
    /* Extract from position 32 */
    uint64_t result = extr64(hi, lo, 32);
    /* hi << 32 = 0x9ABCDEF000000000 */
    /* lo >> 32 = 0x00000000FEDCBA98 */
    /* result = 0x9ABCDEF0FEDCBA98 */
    TEST_ASSERT(result == 0x9ABCDEF0FEDCBA98ULL);
    
    test_printstr("  EXTR: PASS\n");
    return 0;
}

/* Test reverse bits */
static int test_rbit(void) {
    test_printstr("Testing RBIT...\n");
    
    TEST_ASSERT(rbit64(0) == 0);
    TEST_ASSERT(rbit64(1) == 0x8000000000000000ULL);
    TEST_ASSERT(rbit64(0x8000000000000000ULL) == 1);
    TEST_ASSERT(rbit64(0xFFFFFFFFFFFFFFFFULL) == 0xFFFFFFFFFFFFFFFFULL);
    
    test_printstr("  RBIT: PASS\n");
    return 0;
}

/* Test reverse bytes */
static int test_rev(void) {
    test_printstr("Testing REV...\n");
    
    TEST_ASSERT(rev64(0x0102030405060708ULL) == 0x0807060504030201ULL);
    TEST_ASSERT(rev64(0) == 0);
    TEST_ASSERT(rev64(0xFF) == 0xFF00000000000000ULL);
    
    test_printstr("  REV: PASS\n");
    return 0;
}

/* Test CLS (count leading sign bits) */
static int test_cls(void) {
    test_printstr("Testing CLS...\n");
    
    /* Positive number with leading zeros */
    int64_t a = 0x7FFFFFFFFFFFFFFFLL;  /* All 1s except sign bit */
    int cls = 0;
    int sign = (a >> 63) & 1;
    for (int i = 62; i >= 0; i--) {
        if (((a >> i) & 1) != sign) break;
        cls++;
    }
    TEST_ASSERT(cls == 0);  /* Sign is 0, next bit is 1 */
    
    /* Negative number */
    a = -1;  /* 0xFFFF... */
    cls = 0;
    sign = (a >> 63) & 1;
    for (int i = 62; i >= 0; i--) {
        if (((a >> i) & 1) != sign) break;
        cls++;
    }
    TEST_ASSERT(cls == 63);  /* All bits same as sign */
    
    test_printstr("  CLS: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Rotate and Bit Insert Tests ===\n");
    
    test_ror();
    test_rol();
    test_extr();
    test_rbit();
    test_rev();
    test_cls();
    
    test_printstr("All rotate and bit insert tests passed!\n");
    test_pass();
    return 0;
}
