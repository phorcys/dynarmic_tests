/*
 * Register Overlap and Edge Cases
 * Tests various register overlap scenarios that stress the JIT
 */

#include "test_syscall.h"

/* Test self-modifying operations */
static int test_self_modify(void) {
    test_printstr("Testing self-modifying operations...\n");
    
    /* Add to self */
    int64_t x = 10;
    x = x + x;  /* x = 20 */
    TEST_ASSERT(x == 20);
    
    /* Multiply by self */
    x = x * x;  /* x = 400 */
    TEST_ASSERT(x == 400);
    
    /* Subtract from self */
    x = x - x;  /* x = 0 */
    TEST_ASSERT(x == 0);
    
    /* XOR with self */
    x = 0x12345678;
    x = x ^ x;  /* x = 0 */
    TEST_ASSERT(x == 0);
    
    /* AND with self */
    x = 0xFF;
    x = x & x;  /* x = 0xFF */
    TEST_ASSERT(x == 0xFF);
    
    /* OR with self */
    x = 0xF0;
    x = x | x;  /* x = 0xF0 */
    TEST_ASSERT(x == 0xF0);
    
    test_printstr("  Self-modify: PASS\n");
    return 0;
}

/* Test chained operations with same register */
static int test_chained_ops(void) {
    test_printstr("Testing chained operations...\n");
    
    int64_t a = 1;
    
    /* Chain of additions */
    a = a + 1;  /* 2 */
    a = a + 1;  /* 3 */
    a = a + a;  /* 6 */
    a = a + a;  /* 12 */
    TEST_ASSERT(a == 12);
    
    /* Chain with immediate */
    a = a + 10;  /* 22 */
    a = a - 2;   /* 20 */
    a = a * 2;   /* 40 */
    TEST_ASSERT(a == 40);
    
    /* Chain of shifts */
    a = 1;
    a = a << 1;  /* 2 */
    a = a << 2;  /* 8 */
    a = a << 3;  /* 64 */
    TEST_ASSERT(a == 64);
    
    test_printstr("  Chained ops: PASS\n");
    return 0;
}

/* Test three-operand instructions with register overlap */
static int test_three_operand_overlap(void) {
    test_printstr("Testing three-operand overlap...\n");
    
    /* Add with destination same as source 1 */
    int64_t a = 10, b = 5;
    a = a + b;  /* a = 15 */
    TEST_ASSERT(a == 15);
    TEST_ASSERT(b == 5);
    
    /* Add with destination same as source 2 */
    a = 10;
    b = 5;
    b = a + b;  /* b = 15 */
    TEST_ASSERT(a == 10);
    TEST_ASSERT(b == 15);
    
    /* Multiply with overlap */
    a = 3;
    a = a * a;  /* a = 9 */
    TEST_ASSERT(a == 9);
    
    /* Shift with overlap */
    a = 4;
    a = a << a;  /* a = 4 << 4 = 64 */
    TEST_ASSERT(a == 64);
    
    test_printstr("  Three-operand overlap: PASS\n");
    return 0;
}

/* Test conditional with same destination */
static int test_cond_overlap(void) {
    test_printstr("Testing conditional overlap...\n");
    
    int64_t a = 10;
    int64_t b = 20;
    
    /* Conditional move with overlap */
    a = (a < b) ? a : b;  /* a stays 10 */
    TEST_ASSERT(a == 10);
    
    a = (a > b) ? a : b;  /* a becomes 20 */
    TEST_ASSERT(a == 20);
    
    /* Nested ternary with self */
    a = 5;
    a = (a > 0) ? (a < 10 ? a * 2 : a) : -a;
    TEST_ASSERT(a == 10);
    
    test_printstr("  Conditional overlap: PASS\n");
    return 0;
}

/* Test load/store with same register */
static int test_memory_overlap(void) {
    test_printstr("Testing memory overlap...\n");
    
    int64_t arr[8];
    int64_t idx = 0;
    
    /* Store and load same index */
    arr[idx] = 42;
    int64_t val = arr[idx];
    TEST_ASSERT(val == 42);
    
    /* Index modifies self */
    idx = idx + 1;
    arr[idx] = 100;
    val = arr[idx];
    TEST_ASSERT(val == 100);
    
    /* Array sum with index overlap */
    for (int i = 0; i < 8; i++) {
        arr[i] = i;
    }
    
    int64_t sum = 0;
    idx = 0;
    while (idx < 8) {
        sum += arr[idx];
        idx++;
    }
    TEST_ASSERT(sum == 28);  /* 0+1+...+7 */
    
    test_printstr("  Memory overlap: PASS\n");
    return 0;
}

/* Test function with many overlapping parameters */
static int64_t overlap_func(int64_t a, int64_t b, int64_t c) {
    a = a + b;      /* a modified */
    b = a * c;      /* b uses new a */
    c = a - b;      /* c uses new a and b */
    return a + b + c;
}

static int test_func_overlap(void) {
    test_printstr("Testing function overlap...\n");
    
    int64_t result = overlap_func(2, 3, 4);
    /* a = 2 + 3 = 5 */
    /* b = 5 * 4 = 20 */
    /* c = 5 - 20 = -15 */
    /* return 5 + 20 + (-15) = 10 */
    TEST_ASSERT(result == 10);
    
    test_printstr("  Function overlap: PASS\n");
    return 0;
}

/* Test bit operations with overlap */
static int test_bit_overlap(void) {
    test_printstr("Testing bit operations overlap...\n");
    
    uint64_t x = 0xFF;
    
    /* AND with shifted self */
    x = x & (x >> 4);  /* 0xFF & 0x0F = 0x0F */
    TEST_ASSERT(x == 0x0F);
    
    /* OR with shifted self */
    x = 0x0F;
    x = x | (x << 4);  /* 0x0F | 0xF0 = 0xFF */
    TEST_ASSERT(x == 0xFF);
    
    /* XOR with shifted self */
    x = 0xFF;
    x = x ^ (x >> 4);  /* 0xFF ^ 0x0F = 0xF0 */
    TEST_ASSERT(x == 0xF0);
    
    test_printstr("  Bit operations overlap: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Register Overlap Tests ===\n");
    
    test_self_modify();
    test_chained_ops();
    test_three_operand_overlap();
    test_cond_overlap();
    test_memory_overlap();
    test_func_overlap();
    test_bit_overlap();
    
    test_printstr("=== All register overlap tests passed ===\n");
    test_pass();
    return 0;
}
