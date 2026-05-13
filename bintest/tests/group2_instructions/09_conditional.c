// Test conditional execution
#include "test_syscall.h"

int max_int(int a, int b) {
    return (a > b) ? a : b;
}

int min_int(int a, int b) {
    return (a < b) ? a : b;
}

int test_main(void) {
    test_printstr("Testing conditional execution...\n");
    
    // Test 1: Basic conditional select
    int r1 = (1) ? 100 : 200;
    int r2 = (0) ? 100 : 200;
    test_printstr("  select: ");
    test_printint(r1);
    test_printstr(", ");
    test_printint(r2);
    TEST_ASSERT(r1 == 100 && r2 == 200);
    
    // Test 2: Max/min
    int r3 = max_int(10, 20);
    int r4 = min_int(10, 20);
    test_printstr("\n  max(10,20): ");
    test_printint(r3);
    test_printstr(", min(10,20): ");
    test_printint(r4);
    TEST_ASSERT(r3 == 20 && r4 == 10);
    
    // Test 3: Short-circuit AND
    int r5a = (1 && 1);
    int r5b = (0 && 1);
    test_printstr("\n  short_and(1,1): ");
    test_printint(r5a);
    test_printstr(", short_and(0,1): ");
    test_printint(r5b);
    TEST_ASSERT(r5a == 1 && r5b == 0);
    
    // Test 4: Short-circuit OR
    int r6a = (0 || 1);
    int r6b = (0 || 0);
    test_printstr("\n  short_or(0,1): ");
    test_printint(r6a);
    test_printstr(", short_or(0,0): ");
    test_printint(r6b);
    TEST_ASSERT(r6a == 1 && r6b == 0);
    
    // Test 5: Ternary chain
    int x = -5;
    int r7a = (x < 0) ? -1 : (x > 0) ? 1 : 0;
    x = 0;
    int r7b = (x < 0) ? -1 : (x > 0) ? 1 : 0;
    x = 5;
    int r7c = (x < 0) ? -1 : (x > 0) ? 1 : 0;
    test_printstr("\n  ternary_chain: ");
    test_printint(r7a);
    test_printstr(", ");
    test_printint(r7b);
    test_printstr(", ");
    test_printint(r7c);
    TEST_ASSERT(r7a == -1 && r7b == 0 && r7c == 1);
    
    // Test 6: If-else
    int val = 0;
    if (1) {
        val = 42;
    } else {
        val = 100;
    }
    test_printstr("\n  if-else: ");
    test_printint(val);
    TEST_ASSERT(val == 42);
    
    test_printstr("\nAll conditional tests passed!\n");
    test_pass();
    return 0;
}