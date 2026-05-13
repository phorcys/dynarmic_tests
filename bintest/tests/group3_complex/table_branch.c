/*
 * Table Branch Test
 * Tests TBZ, TBNZ, table-based branching patterns
 */

#include "test_syscall.h"

/* Test test bit and branch if zero */
static int test_tbz(void) {
    test_printstr("Testing TBZ...\n");
    
    uint64_t x = 0x10;  /* Bit 4 set */
    
    int branch_taken = 0;
    
    /* Test if bit 4 is zero */
    if ((x & (1ULL << 4)) == 0) {
        branch_taken = 1;
    }
    TEST_ASSERT(branch_taken == 0);  /* Bit 4 is set, not zero */
    
    /* Test if bit 5 is zero */
    if ((x & (1ULL << 5)) == 0) {
        branch_taken = 1;
    }
    TEST_ASSERT(branch_taken == 1);  /* Bit 5 is zero */
    
    test_printstr("  TBZ: PASS\n");
    return 0;
}

/* Test test bit and branch if not zero */
static int test_tbnz(void) {
    test_printstr("Testing TBNZ...\n");
    
    uint64_t x = 0x10;  /* Bit 4 set */
    
    int branch_taken = 0;
    
    /* Test if bit 4 is set */
    if (x & (1ULL << 4)) {
        branch_taken = 1;
    }
    TEST_ASSERT(branch_taken == 1);
    
    /* Test if bit 5 is set */
    branch_taken = 0;
    if (x & (1ULL << 5)) {
        branch_taken = 1;
    }
    TEST_ASSERT(branch_taken == 0);
    
    test_printstr("  TBNZ: PASS\n");
    return 0;
}

/* Test bit scanning patterns */
static int test_bit_scan(void) {
    test_printstr("Testing bit scan...\n");
    
    /* Find first set bit */
    uint64_t x = 0x1000;
    int pos = -1;
    
    for (int i = 0; i < 64; i++) {
        if (x & (1ULL << i)) {
            pos = i;
            break;
        }
    }
    TEST_ASSERT(pos == 12);
    
    /* Find last set bit */
    x = 0xF000;
    pos = -1;
    for (int i = 63; i >= 0; i--) {
        if (x & (1ULL << i)) {
            pos = i;
            break;
        }
    }
    TEST_ASSERT(pos == 15);
    
    test_printstr("  Bit scan: PASS\n");
    return 0;
}

/* Test table-based dispatch */
static int test_table_dispatch(void) {
    test_printstr("Testing table dispatch...\n");
    
    /* Simulate switch statement with jump table */
    int dispatch_table[] = { 100, 200, 300, 400, 500 };
    
    int idx = 2;
    int result = dispatch_table[idx];
    TEST_ASSERT(result == 300);
    
    idx = 4;
    result = dispatch_table[idx];
    TEST_ASSERT(result == 500);
    
    test_printstr("  Table dispatch: PASS\n");
    return 0;
}

/* Test conditional bit operations */
static int test_cond_bit(void) {
    test_printstr("Testing cond bit...\n");
    
    uint64_t flags = 0;
    
    /* Set bits conditionally */
    int a = 10, b = 20;
    
    if (a < b) flags |= (1ULL << 0);
    if (a == b) flags |= (1ULL << 1);
    if (a > b) flags |= (1ULL << 2);
    
    TEST_ASSERT(flags == 1);  /* Only bit 0 should be set */
    
    /* Clear bits conditionally */
    flags = 0xFF;
    if (a < b) flags &= ~(1ULL << 7);
    
    TEST_ASSERT(flags == 0x7F);
    
    test_printstr("  Cond bit: PASS\n");
    return 0;
}

/* Test bit mask operations */
static int test_bitmask(void) {
    test_printstr("Testing bitmask...\n");
    
    /* Create bitmask */
    uint64_t mask = 0;
    for (int i = 4; i < 12; i++) {
        mask |= (1ULL << i);
    }
    TEST_ASSERT(mask == 0xFF0);
    
    /* Apply mask */
    uint64_t x = 0x123456;
    uint64_t result = x & mask;
    TEST_ASSERT(result == 0x450);
    
    /* Invert and apply */
    result = x & ~mask;
    TEST_ASSERT(result == 0x123006);
    
    test_printstr("  Bitmask: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Table Branch Tests ===\n");
    
    test_tbz();
    test_tbnz();
    test_bit_scan();
    test_table_dispatch();
    test_cond_bit();
    test_bitmask();
    
    test_printstr("All table branch tests passed!\n");
    test_pass();
    return 0;
}
