/* Test: Nested function calls */
#include "test_syscall.h"

// Deeply nested calls
static long level3(long x) {
    return x + 1;
}

static long level2(long x) {
    return level3(x) * 2;
}

static long level1(long x) {
    return level2(x) + 10;
}

// Functions that call each other
static long helper(long x, long y) {
    return x - y;
}

static long compute(long a, long b, long c) {
    long t1 = helper(a, b);
    long t2 = helper(b, c);
    return t1 + t2;
}

int test_main(void) {
    test_printstr("Testing nested function calls...\n");
    
    // Test nested levels
    long r1 = level1(5);
    // level1(5) = level2(5) + 10 = level3(5) * 2 + 10 = (5+1) * 2 + 10 = 12 + 10 = 22
    TEST_ASSERT(r1 == 22);
    test_printstr("  level1(5) = ");
    test_printint(r1);
    test_newline();
    
    // Test compute
    long r2 = compute(10, 3, 1);
    // compute(10, 3, 1) = helper(10, 3) + helper(3, 1) = 7 + 2 = 9
    TEST_ASSERT(r2 == 9);
    test_printstr("  compute(10, 3, 1) = ");
    test_printint(r2);
    test_newline();
    
    // Deep chain with callee-saved registers
    long r3 = level1(level1(0));
    // level1(0) = 12, level1(12) = level2(12) + 10 = level3(12) * 2 + 10 = 13 * 2 + 10 = 36
    test_printstr("  level1(level1(0)) = ");
    test_printint(r3);
    test_newline();
    
    test_printstr("All nested call tests passed!\n");
    test_pass();
    return 0;
}
