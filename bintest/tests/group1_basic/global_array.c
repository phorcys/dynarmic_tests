// Global Array Test
// Tests: Global array initialization and access across function calls
#include "test_syscall.h"

static int global_arr[256];  // Same as KMP's lps array

void init_global(int size) {
    for (int i = 0; i < size; i++) {
        global_arr[i] = i;
    }
}

void compute_lps_like(const char *pattern, int m) {
    // Mimics KMP's compute_lps function
    int len = 0;
    global_arr[0] = 0;

    int i = 1;
    while (i < m) {
        if (pattern[i] == pattern[len]) {
            len++;
            global_arr[i] = len;
            i++;
        } else {
            if (len != 0) {
                len = global_arr[len - 1];
            } else {
                global_arr[i] = 0;
                i++;
            }
        }
    }
}

int test_main(void) {
    test_printstr("Testing Global Array...\n");

    // Test 1: Simple global array
    init_global(10);
    test_printstr("  init: ");
    test_printint(global_arr[0]);
    test_printstr(",");
    test_printint(global_arr[5]);
    test_printstr(",");
    test_printint(global_arr[9]);
    TEST_ASSERT(global_arr[0] == 0);
    TEST_ASSERT(global_arr[5] == 5);
    TEST_ASSERT(global_arr[9] == 9);
    test_printstr(" OK\n");

    // Test 2: LPS-like computation for "ABA"
    // Expected LPS: [0, 0, 1]
    compute_lps_like("ABA", 3);
    test_printstr("  lps_ABA: ");
    test_printint(global_arr[0]);
    test_printstr(",");
    test_printint(global_arr[1]);
    test_printstr(",");
    test_printint(global_arr[2]);
    TEST_ASSERT(global_arr[0] == 0);
    TEST_ASSERT(global_arr[1] == 0);
    TEST_ASSERT(global_arr[2] == 1);
    test_printstr(" OK\n");

    // Test 3: LPS for "ABABCABAB"
    // Expected: [0, 0, 1, 2, 0, 1, 2, 3, 4]
    compute_lps_like("ABABCABAB", 9);
    test_printstr("  lps_ABABCABAB: ");
    test_printint(global_arr[0]);
    test_printstr(",");
    test_printint(global_arr[4]);
    test_printstr(",");
    test_printint(global_arr[8]);
    TEST_ASSERT(global_arr[0] == 0);
    TEST_ASSERT(global_arr[4] == 0);
    TEST_ASSERT(global_arr[8] == 4);
    test_printstr(" OK\n");

    // Test 4: LPS for "AAAA"
    // Expected: [0, 1, 2, 3]
    compute_lps_like("AAAA", 4);
    test_printstr("  lps_AAAA: ");
    test_printint(global_arr[0]);
    test_printstr(",");
    test_printint(global_arr[1]);
    test_printstr(",");
    test_printint(global_arr[2]);
    test_printstr(",");
    test_printint(global_arr[3]);
    TEST_ASSERT(global_arr[0] == 0);
    TEST_ASSERT(global_arr[1] == 1);
    TEST_ASSERT(global_arr[2] == 2);
    TEST_ASSERT(global_arr[3] == 3);
    test_printstr(" OK\n");

    test_printstr("All global array tests passed!\n");
    test_pass();
    return 0;
}
