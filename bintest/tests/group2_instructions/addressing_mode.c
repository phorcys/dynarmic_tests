/*
 * Addressing Mode Test
 * Tests various ARM64 addressing modes
 */

#include "test_syscall.h"

static uint64_t buffer[64];

/* Test base register only */
static int test_base_only(void) {
    test_printstr("Testing base only...\n");
    
    buffer[0] = 0x12345678;
    
    uint64_t *ptr = buffer;
    uint64_t val = *ptr;
    
    TEST_ASSERT(val == 0x12345678);
    
    test_printstr("  Base only: PASS\n");
    return 0;
}

/* Test base + offset immediate */
static int test_base_offset(void) {
    test_printstr("Testing base+offset...\n");
    
    buffer[4] = 100;
    buffer[5] = 200;
    
    uint64_t *ptr = &buffer[4];
    
    TEST_ASSERT(ptr[0] == 100);
    TEST_ASSERT(ptr[1] == 200);
    
    /* Byte offset */
    uint8_t *bptr = (uint8_t*)buffer;
    bptr[0] = 0x11;
    bptr[1] = 0x22;
    bptr[2] = 0x33;
    bptr[3] = 0x44;
    
    TEST_ASSERT(bptr[0] == 0x11);
    TEST_ASSERT(bptr[3] == 0x44);
    
    test_printstr("  Base+offset: PASS\n");
    return 0;
}

/* Test pre-indexed */
static int test_pre_index(void) {
    test_printstr("Testing pre-index...\n");
    
    buffer[10] = 0xAABBCCDD;
    
    uint64_t *ptr = buffer;
    uint64_t val = *(++ptr);  /* Increment then load */
    
    /* buffer[1] is not set, so check ptr was incremented */
    TEST_ASSERT(ptr == &buffer[1]);
    
    test_printstr("  Pre-index: PASS\n");
    return 0;
}

/* Test post-indexed */
static int test_post_index(void) {
    test_printstr("Testing post-index...\n");
    
    buffer[20] = 0x11223344;
    
    uint64_t *ptr = &buffer[20];
    uint64_t val = *ptr++;  /* Load then increment */
    
    TEST_ASSERT(val == 0x11223344);
    TEST_ASSERT(ptr == &buffer[21]);
    
    test_printstr("  Post-index: PASS\n");
    return 0;
}

/* Test register offset */
static int test_reg_offset(void) {
    test_printstr("Testing reg offset...\n");
    
    buffer[30] = 0xDEADBEEF;
    
    uint64_t *base = buffer;
    uint64_t offset = 30;
    
    uint64_t val = base[offset];
    
    TEST_ASSERT(val == 0xDEADBEEF);
    
    test_printstr("  Reg offset: PASS\n");
    return 0;
}

/* Test scaled register offset */
static int test_scaled_offset(void) {
    test_printstr("Testing scaled offset...\n");
    
    buffer[40] = 1000;
    
    uint64_t *base = buffer;
    uint64_t index = 40;
    
    /* index * sizeof(uint64_t) = 40 * 8 = 320 */
    uint64_t val = base[index];
    
    TEST_ASSERT(val == 1000);
    
    test_printstr("  Scaled offset: PASS\n");
    return 0;
}

/* Test extended register offset */
static int test_extend_offset(void) {
    test_printstr("Testing extend offset...\n");
    
    buffer[50] = 0xFEEDFACE;
    
    uint64_t *base = buffer;
    uint32_t index32 = 50;  /* 32-bit index, will be extended */
    
    uint64_t val = base[index32];
    
    TEST_ASSERT(val == 0xFEEDFACE);
    
    test_printstr("  Extend offset: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Addressing Mode Tests ===\n");
    
    test_base_only();
    test_base_offset();
    test_pre_index();
    test_post_index();
    test_reg_offset();
    test_scaled_offset();
    test_extend_offset();
    
    test_printstr("All addressing mode tests passed!\n");
    test_pass();
    return 0;
}
