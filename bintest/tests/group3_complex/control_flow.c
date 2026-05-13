/*
 * Complex Control Flow Test
 * Tests various branch patterns and control flow
 */

#include "test_syscall.h"

/* Jump table simulation */
static const char* get_day_name(int day) {
    static const char* names[] = {
        "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
    };
    if (day >= 0 && day < 7) {
        return names[day];
    }
    return "Invalid";
}

/* Complex conditional chains */
static int classify_number(int64_t n) {
    if (n < 0) {
        if (n < -1000) return -2;
        if (n < -100) return -1;
        return 0;
    } else if (n == 0) {
        return 0;
    } else {
        if (n > 1000) return 2;
        if (n > 100) return 1;
        return 0;
    }
}

/* Loop with multiple exits */
static int find_first(int64_t *arr, int n, int64_t target) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == target) return i;
        if (arr[i] < 0) break;  /* Early exit on negative */
    }
    return -1;
}

/* Nested loops with conditions */
static int count_pairs(int64_t *arr, int n, int64_t target) {
    int count = 0;
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            if (arr[i] + arr[j] == target) {
                count++;
            }
        }
    }
    return count;
}

/* State machine */
typedef enum {
    S_START, S_A, S_B, S_C, S_ACCEPT, S_REJECT
} State;

static State run_fsm(const char *input) {
    State state = S_START;
    
    for (int i = 0; input[i] != '\0'; i++) {
        char c = input[i];
        switch (state) {
            case S_START:
                if (c == 'a') state = S_A;
                else state = S_REJECT;
                break;
            case S_A:
                if (c == 'b') state = S_B;
                else if (c == 'a') state = S_A;
                else state = S_REJECT;
                break;
            case S_B:
                if (c == 'c') state = S_ACCEPT;
                else if (c == 'a') state = S_A;
                else state = S_REJECT;
                break;
            case S_ACCEPT:
                state = S_REJECT;  /* No more chars expected */
                break;
            default:
                break;
        }
    }
    
    return state;
}

/* Test jump table */
static int test_jump_table(void) {
    test_printstr("Testing jump table...\n");
    
    TEST_ASSERT(get_day_name(0)[0] == 'S');  /* Sun */
    TEST_ASSERT(get_day_name(1)[0] == 'M');  /* Mon */
    TEST_ASSERT(get_day_name(6)[0] == 'S');  /* Sat */
    TEST_ASSERT(get_day_name(7)[0] == 'I');  /* Invalid */
    
    test_printstr("  Jump table: PASS\n");
    return 0;
}

/* Test conditional chains */
static int test_cond_chains(void) {
    test_printstr("Testing conditional chains...\n");
    
    TEST_ASSERT(classify_number(-2000) == -2);
    TEST_ASSERT(classify_number(-500) == -1);
    TEST_ASSERT(classify_number(-50) == 0);
    TEST_ASSERT(classify_number(0) == 0);
    TEST_ASSERT(classify_number(50) == 0);
    TEST_ASSERT(classify_number(500) == 1);
    TEST_ASSERT(classify_number(2000) == 2);
    
    test_printstr("  Cond chains: PASS\n");
    return 0;
}

/* Test early exit loops */
static int test_early_exit(void) {
    test_printstr("Testing early exit...\n");
    
    int64_t arr[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    
    TEST_ASSERT(find_first(arr, 10, 5) == 4);
    TEST_ASSERT(find_first(arr, 10, 1) == 0);
    TEST_ASSERT(find_first(arr, 10, 10) == 9);
    TEST_ASSERT(find_first(arr, 10, 20) == -1);
    
    /* Test early break */
    int64_t arr2[] = {1, 2, -1, 4, 5};
    TEST_ASSERT(find_first(arr2, 5, 4) == -1);  /* Breaks before reaching 4 */
    TEST_ASSERT(find_first(arr2, 5, 2) == 1);
    
    test_printstr("  Early exit: PASS\n");
    return 0;
}

/* Test nested loops */
static int test_nested_loops(void) {
    test_printstr("Testing nested loops...\n");
    
    int64_t arr[] = {1, 2, 3, 4, 5};
    TEST_ASSERT(count_pairs(arr, 5, 5) == 2);  /* (1,4), (2,3) */
    TEST_ASSERT(count_pairs(arr, 5, 6) == 2);  /* (1,5), (2,4) */
    TEST_ASSERT(count_pairs(arr, 5, 9) == 1);  /* (4,5) */
    TEST_ASSERT(count_pairs(arr, 5, 100) == 0);
    
    test_printstr("  Nested loops: PASS\n");
    return 0;
}

/* Test state machine */
static int test_state_machine(void) {
    test_printstr("Testing state machine...\n");
    
    TEST_ASSERT(run_fsm("abc") == S_ACCEPT);
    TEST_ASSERT(run_fsm("aabc") == S_ACCEPT);
    TEST_ASSERT(run_fsm("aaabc") == S_ACCEPT);
    TEST_ASSERT(run_fsm("ab") == S_B);  /* Not complete */
    TEST_ASSERT(run_fsm("ac") == S_REJECT);
    TEST_ASSERT(run_fsm("bc") == S_REJECT);
    TEST_ASSERT(run_fsm("") == S_START);
    
    test_printstr("  State machine: PASS\n");
    return 0;
}

/* Test computed goto simulation via switch */
static int test_switch_fallthrough(void) {
    test_printstr("Testing switch patterns...\n");
    
    int count = 0;
    int value = 2;
    
    switch (value) {
        case 0: count++;
        case 1: count++;
        case 2: count++;
        case 3: count++;
        case 4: count++;
            break;
        default:
            count = -1;
    }
    /* Falls through from 2: count = 3 */
    TEST_ASSERT(count == 3);
    
    test_printstr("  Switch patterns: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Control Flow Tests ===\n");
    
    test_jump_table();
    test_cond_chains();
    test_early_exit();
    test_nested_loops();
    test_state_machine();
    test_switch_fallthrough();
    
    test_printstr("All control flow tests passed!\n");
    test_pass();
    return 0;
}
