/*
 * Stack Operations Stress Test
 * Tests deep recursion, large stack frames, stack alignment
 */

#include "test_syscall.h"

/* Deep recursion test */
static int deep_recurse(int n) {
    if (n <= 0) return 0;
    return 1 + deep_recurse(n - 1);
}

/* Tail recursion (may be optimized) */
static int tail_recurse(int n, int acc) {
    if (n <= 0) return acc;
    return tail_recurse(n - 1, acc + 1);
}

/* Mutual recursion */
static int mutual_a(int n);
static int mutual_b(int n);

static int mutual_a(int n) {
    if (n <= 0) return 0;
    return 1 + mutual_b(n - 1);
}

static int mutual_b(int n) {
    if (n <= 0) return 0;
    return 1 + mutual_a(n - 1);
}

/* Large stack frame */
static int large_frame(void) {
    volatile int big[256];  /* 1KB on stack */
    
    for (int i = 0; i < 256; i++) {
        big[i] = i;
    }
    
    int sum = 0;
    for (int i = 0; i < 256; i++) {
        sum += big[i];
    }
    return sum;
}

/* Variable length array simulation */
static int vla_simulate(int size) {
    int arr[128];  /* Max size */
    
    for (int i = 0; i < size && i < 128; i++) {
        arr[i] = i * 2;
    }
    
    int sum = 0;
    for (int i = 0; i < size && i < 128; i++) {
        sum += arr[i];
    }
    return sum;
}

/* Test deep recursion */
static int test_deep_recursion(void) {
    test_printstr("Testing deep recursion...\n");
    
    int result = deep_recurse(50);
    TEST_ASSERT(result == 50);
    
    result = deep_recurse(100);
    TEST_ASSERT(result == 100);
    
    test_printstr("  Deep recursion: PASS\n");
    return 0;
}

/* Test tail recursion */
static int test_tail_recursion(void) {
    test_printstr("Testing tail recursion...\n");
    
    int result = tail_recurse(50, 0);
    TEST_ASSERT(result == 50);
    
    result = tail_recurse(100, 0);
    TEST_ASSERT(result == 100);
    
    test_printstr("  Tail recursion: PASS\n");
    return 0;
}

/* Test mutual recursion */
static int test_mutual_recursion(void) {
    test_printstr("Testing mutual recursion...\n");
    
    int result = mutual_a(20);
    TEST_ASSERT(result == 20);
    
    result = mutual_b(20);
    TEST_ASSERT(result == 20);
    
    test_printstr("  Mutual recursion: PASS\n");
    return 0;
}

/* Test large stack frame */
static int test_large_frame(void) {
    test_printstr("Testing large frame...\n");
    
    int result = large_frame();
    TEST_ASSERT(result == 256 * 255 / 2);  /* Sum 0..255 */
    
    test_printstr("  Large frame: PASS\n");
    return 0;
}

/* Test nested calls */
static int test_nested_calls(void) {
    test_printstr("Testing nested calls...\n");
    
    /* Fibonacci using recursion */
    int fib(int n) {
        if (n <= 1) return n;
        return fib(n - 1) + fib(n - 2);
    }
    
    int f10 = fib(10);
    TEST_ASSERT(f10 == 55);
    
    int f15 = fib(15);
    TEST_ASSERT(f15 == 610);
    
    test_printstr("  Nested calls: PASS\n");
    return 0;
}

/* Test VLA simulation */
static int test_vla(void) {
    test_printstr("Testing VLA...\n");
    
    int result = vla_simulate(10);
    TEST_ASSERT(result == 0 + 2 + 4 + 6 + 8 + 10 + 12 + 14 + 16 + 18);
    
    result = vla_simulate(5);
    TEST_ASSERT(result == 0 + 2 + 4 + 6 + 8);
    
    test_printstr("  VLA: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Stack Stress Tests ===\n");
    
    test_deep_recursion();
    test_tail_recursion();
    test_mutual_recursion();
    test_large_frame();
    test_nested_calls();
    test_vla();
    
    test_printstr("All stack stress tests passed!\n");
    test_pass();
    return 0;
}