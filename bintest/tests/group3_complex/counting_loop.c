/*
 * Counting Loop Test
 * Tests loop patterns with counter registers
 */

#include "test_syscall.h"

/* Simple counting loop */
static int test_simple_loop(void) {
    test_printstr("Testing simple loop...\n");
    
    int sum = 0;
    for (int i = 1; i <= 10; i++) {
        sum += i;
    }
    TEST_ASSERT(sum == 55);  /* 1+2+...+10 = 55 */
    
    test_printstr("  Simple loop: PASS\n");
    return 0;
}

/* Downward counting loop */
static int test_downward_loop(void) {
    test_printstr("Testing downward loop...\n");
    
    int product = 1;
    for (int i = 5; i >= 1; i--) {
        product *= i;
    }
    TEST_ASSERT(product == 120);  /* 5! = 120 */
    
    test_printstr("  Downward loop: PASS\n");
    return 0;
}

/* Nested loops */
static int test_nested_loop(void) {
    test_printstr("Testing nested loop...\n");
    
    int count = 0;
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            count++;
        }
    }
    TEST_ASSERT(count == 25);
    
    test_printstr("  Nested loop: PASS\n");
    return 0;
}

/* Loop with early break */
static int test_loop_break(void) {
    test_printstr("Testing loop break...\n");
    
    int found = -1;
    for (int i = 0; i < 100; i++) {
        if (i == 42) {
            found = i;
            break;
        }
    }
    TEST_ASSERT(found == 42);
    
    test_printstr("  Loop break: PASS\n");
    return 0;
}

/* Loop with continue */
static int test_loop_continue(void) {
    test_printstr("Testing loop continue...\n");
    
    int sum = 0;
    for (int i = 0; i < 10; i++) {
        if (i % 2 == 0) continue;  /* Skip even numbers */
        sum += i;
    }
    TEST_ASSERT(sum == 25);  /* 1+3+5+7+9 = 25 */
    
    test_printstr("  Loop continue: PASS\n");
    return 0;
}

/* While loop */
static int test_while_loop(void) {
    test_printstr("Testing while loop...\n");
    
    int n = 1024;
    int divisions = 0;
    while (n > 1) {
        n /= 2;
        divisions++;
    }
    TEST_ASSERT(divisions == 10);
    
    test_printstr("  While loop: PASS\n");
    return 0;
}

/* Do-while loop */
static int test_dowhile_loop(void) {
    test_printstr("Testing do-while loop...\n");
    
    int n = 1;
    int iterations = 0;
    do {
        n *= 2;
        iterations++;
    } while (n < 100);
    TEST_ASSERT(iterations == 7);  /* 1,2,4,8,16,32,64,128 */
    
    test_printstr("  Do-while loop: PASS\n");
    return 0;
}

/* Loop unrolling pattern */
static int test_loop_unroll(void) {
    test_printstr("Testing loop unroll...\n");
    
    int arr[8] = {1, 2, 3, 4, 5, 6, 7, 8};
    int sum = 0;
    
    /* Manually unrolled by 4 */
    for (int i = 0; i < 8; i += 4) {
        sum += arr[i];
        sum += arr[i+1];
        sum += arr[i+2];
        sum += arr[i+3];
    }
    TEST_ASSERT(sum == 36);
    
    test_printstr("  Loop unroll: PASS\n");
    return 0;
}

/* Infinite loop with condition */
static int test_infinite_loop(void) {
    test_printstr("Testing infinite loop pattern...\n");
    
    int counter = 0;
    int result = 0;
    
    for (;;) {  /* Infinite loop */
        counter++;
        result += counter;
        if (counter >= 10) break;
    }
    TEST_ASSERT(result == 55);
    
    test_printstr("  Infinite loop: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Counting Loop Tests ===\n");
    
    test_simple_loop();
    test_downward_loop();
    test_nested_loop();
    test_loop_break();
    test_loop_continue();
    test_while_loop();
    test_dowhile_loop();
    test_loop_unroll();
    test_infinite_loop();
    
    test_printstr("All counting loop tests passed!\n");
    test_pass();
    return 0;
}
