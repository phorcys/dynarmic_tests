/*
 * Advanced Branch Test
 * Tests complex control flow patterns
 */

#include "test_syscall.h"

/* State machine */
typedef enum {
    STATE_INIT,
    STATE_A,
    STATE_B,
    STATE_C,
    STATE_DONE
} State;

static State run_state_machine(int input) {
    State state = STATE_INIT;
    
    for (int i = 0; i < 10 && state != STATE_DONE; i++) {
        switch (state) {
            case STATE_INIT:
                if (input > 0) state = STATE_A;
                else state = STATE_B;
                break;
            case STATE_A:
                if (input > 10) state = STATE_C;
                else state = STATE_DONE;
                break;
            case STATE_B:
                state = STATE_C;
                break;
            case STATE_C:
                state = STATE_DONE;
                break;
            case STATE_DONE:
                break;
        }
    }
    return state;
}

/* Binary search with branches */
static int binary_search(int *arr, int n, int target) {
    int lo = 0, hi = n - 1;
    
    while (lo <= hi) {
        int mid = (lo + hi) / 2;
        if (arr[mid] == target) return mid;
        if (arr[mid] < target) lo = mid + 1;
        else hi = mid - 1;
    }
    return -1;
}

/* Compute GCD using branches */
static int gcd(int a, int b) {
    while (b != 0) {
        int t = b;
        b = a % b;
        a = t;
    }
    return a;
}

/* Test state machine */
static int test_state_machine(void) {
    test_printstr("Testing state machine...\n");
    
    State s1 = run_state_machine(5);
    TEST_ASSERT(s1 == STATE_DONE);
    
    State s2 = run_state_machine(15);
    TEST_ASSERT(s2 == STATE_DONE);
    
    State s3 = run_state_machine(0);
    TEST_ASSERT(s3 == STATE_DONE);
    
    test_printstr("  State machine: PASS\n");
    return 0;
}

/* Test binary search */
static int test_binary_search(void) {
    test_printstr("Testing binary search...\n");
    
    int arr[] = { 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 };
    
    int idx = binary_search(arr, 10, 7);
    TEST_ASSERT(idx == 3);
    
    idx = binary_search(arr, 10, 1);
    TEST_ASSERT(idx == 0);
    
    idx = binary_search(arr, 10, 19);
    TEST_ASSERT(idx == 9);
    
    idx = binary_search(arr, 10, 8);
    TEST_ASSERT(idx == -1);
    
    test_printstr("  Binary search: PASS\n");
    return 0;
}

/* Test GCD */
static int test_gcd(void) {
    test_printstr("Testing GCD...\n");
    
    TEST_ASSERT(gcd(48, 18) == 6);
    TEST_ASSERT(gcd(100, 25) == 25);
    TEST_ASSERT(gcd(17, 13) == 1);
    TEST_ASSERT(gcd(1000, 500) == 500);
    TEST_ASSERT(gcd(7, 7) == 7);
    
    test_printstr("  GCD: PASS\n");
    return 0;
}

/* Test nested conditionals */
static int test_nested_cond(void) {
    test_printstr("Testing nested conditionals...\n");
    
    int classify(int x, int y) {
        if (x > 0) {
            if (y > 0) return 1;      /* Quadrant I */
            else if (y < 0) return 4; /* Quadrant IV */
            else return 0;             /* On X axis */
        } else if (x < 0) {
            if (y > 0) return 2;      /* Quadrant II */
            else if (y < 0) return 3; /* Quadrant III */
            else return 0;             /* On X axis */
        } else {
            if (y != 0) return 0;     /* On Y axis */
            else return 0;             /* Origin */
        }
    }
    
    TEST_ASSERT(classify(1, 1) == 1);
    TEST_ASSERT(classify(-1, 1) == 2);
    TEST_ASSERT(classify(-1, -1) == 3);
    TEST_ASSERT(classify(1, -1) == 4);
    TEST_ASSERT(classify(0, 0) == 0);
    TEST_ASSERT(classify(0, 5) == 0);
    TEST_ASSERT(classify(5, 0) == 0);
    
    test_printstr("  Nested conditionals: PASS\n");
    return 0;
}

/* Test complex boolean logic */
static int test_bool_logic(void) {
    test_printstr("Testing boolean logic...\n");
    
    int is_valid(int a, int b, int c) {
        return (a > 0 && b > 0 && c > 0) ||
               (a < 0 && b < 0 && c < 0) ||
               (a == 0 && b == 0 && c == 0);
    }
    
    TEST_ASSERT(is_valid(1, 2, 3) == 1);
    TEST_ASSERT(is_valid(-1, -2, -3) == 1);
    TEST_ASSERT(is_valid(0, 0, 0) == 1);
    TEST_ASSERT(is_valid(1, -1, 0) == 0);
    TEST_ASSERT(is_valid(0, 1, 2) == 0);
    
    test_printstr("  Boolean logic: PASS\n");
    return 0;
}

/* Test early returns */
static int test_early_return(void) {
    test_printstr("Testing early return...\n");
    
    int process(int x) {
        if (x < 0) return -1;
        if (x == 0) return 0;
        if (x > 100) return 100;
        return x * 2;
    }
    
    TEST_ASSERT(process(-5) == -1);
    TEST_ASSERT(process(0) == 0);
    TEST_ASSERT(process(50) == 100);
    TEST_ASSERT(process(100) == 200);
    TEST_ASSERT(process(150) == 100);
    
    test_printstr("  Early return: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Advanced Branch Tests ===\n");
    
    test_state_machine();
    test_binary_search();
    test_gcd();
    test_nested_cond();
    test_bool_logic();
    test_early_return();
    
    test_printstr("All advanced branch tests passed!\n");
    test_pass();
    return 0;
}
