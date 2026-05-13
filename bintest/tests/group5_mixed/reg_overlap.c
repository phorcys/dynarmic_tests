/*
 * Register Overlap Test
 * Tests cases where source and destination registers overlap
 */

#include "test_syscall.h"

/* Test register move with overlap */
static int test_reg_overlap_move(void) {
    test_printstr("Testing reg overlap move...\n");
    
    uint64_t x = 0x12345678ABCDEF00ULL;
    uint64_t y = x;  /* Same value */
    
    TEST_ASSERT(y == x);
    
    /* Self-assignment */
    x = x;
    TEST_ASSERT(x == 0x12345678ABCDEF00ULL);
    
    test_printstr("  Reg overlap move: PASS\n");
    return 0;
}

/* Test arithmetic with same source and dest */
static int test_reg_overlap_arith(void) {
    test_printstr("Testing reg overlap arith...\n");
    
    uint64_t a = 100;
    
    /* Add to self */
    a = a + a;  /* 100 + 100 = 200 */
    TEST_ASSERT(a == 200);
    
    /* Subtract from self */
    a = a - a;  /* 200 - 200 = 0 */
    TEST_ASSERT(a == 0);
    
    /* Multiply by self */
    a = 5;
    a = a * a;  /* 5 * 5 = 25 */
    TEST_ASSERT(a == 25);
    
    test_printstr("  Reg overlap arith: PASS\n");
    return 0;
}

/* Test logical with same source and dest */
static int test_reg_overlap_logic(void) {
    test_printstr("Testing reg overlap logic...\n");
    
    uint64_t a = 0xFF;
    
    /* AND with self */
    a = a & a;
    TEST_ASSERT(a == 0xFF);
    
    /* OR with self */
    a = a | a;
    TEST_ASSERT(a == 0xFF);
    
    /* XOR with self (always 0) */
    a = a ^ a;
    TEST_ASSERT(a == 0);
    
    test_printstr("  Reg overlap logic: PASS\n");
    return 0;
}

/* Test shift with same source and dest */
static int test_reg_overlap_shift(void) {
    test_printstr("Testing reg overlap shift...\n");
    
    uint64_t a = 1;
    
    /* Shift left by self */
    a = a << a;  /* 1 << 1 = 2 */
    TEST_ASSERT(a == 2);
    
    /* Shift right by self */
    a = a >> a;  /* 2 >> 2 = 0 */
    TEST_ASSERT(a == 0);
    
    test_printstr("  Reg overlap shift: PASS\n");
    return 0;
}

/* Test chained operations */
static int test_chained_ops(void) {
    test_printstr("Testing chained ops...\n");
    
    uint64_t x = 10;
    
    /* Chain of operations on same variable */
    x = x + 5;   /* 15 */
    x = x * 2;   /* 30 */
    x = x - 10;  /* 20 */
    x = x / 4;   /* 5 */
    
    TEST_ASSERT(x == 5);
    
    test_printstr("  Chained ops: PASS\n");
    return 0;
}

/* Test swap without temp */
static int test_swap_xor(void) {
    test_printstr("Testing swap XOR...\n");
    
    uint64_t a = 0x12345678;
    uint64_t b = 0xABCDEF00;
    
    /* XOR swap */
    a = a ^ b;
    b = a ^ b;
    a = a ^ b;
    
    TEST_ASSERT(a == 0xABCDEF00);
    TEST_ASSERT(b == 0x12345678);
    
    test_printstr("  Swap XOR: PASS\n");
    return 0;
}

/* Test compound assignment patterns */
static int test_compound(void) {
    test_printstr("Testing compound...\n");
    
    uint64_t x = 100;
    
    x += 50;   /* 150 */
    x -= 30;   /* 120 */
    x *= 2;    /* 240 */
    x /= 3;    /* 80 */
    x &= 0x7F; /* 0 */
    x |= 0x55; /* 0x55 */
    x ^= 0xFF; /* 0xAA */
    
    TEST_ASSERT(x == 0xAA);
    
    test_printstr("  Compound: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Register Overlap Tests ===\n");
    
    test_reg_overlap_move();
    test_reg_overlap_arith();
    test_reg_overlap_logic();
    test_reg_overlap_shift();
    test_chained_ops();
    test_swap_xor();
    test_compound();
    
    test_printstr("All register overlap tests passed!\n");
    test_pass();
    return 0;
}
