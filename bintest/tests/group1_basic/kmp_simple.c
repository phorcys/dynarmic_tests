// KMP-like Pattern Test
// Simulates the exact pattern used in KMP: matches[count++] = i - j
#include "test_syscall.h"

// Simulate KMP search - simplified version
int simple_search(const char *text, int n, const char *pattern, int m, int *matches, int max_matches) {
    int count = 0;

    for (int i = 0; i <= n - m; i++) {
        int match = 1;
        for (int j = 0; j < m; j++) {
            if (text[i + j] != pattern[j]) {
                match = 0;
                break;
            }
        }
        if (match) {
            if (count < max_matches) {
                matches[count] = i;  // Store position
                count++;
            }
        }
    }

    return count;
}

int str_len(const char *s) {
    int len = 0;
    while (s[len]) len++;
    return len;
}

int test_main(void) {
    test_printstr("Testing KMP-like Search...\n");
    int matches[32];
    int count;

    // Test 1: Simple pattern
    const char *text1 = "ABABDABACDABABCABAB";
    const char *pattern1 = "ABABCABAB";
    count = simple_search(text1, str_len(text1), pattern1, str_len(pattern1), matches, 32);
    test_printstr("  simple: ");
    test_printint(count);
    test_printstr(" at ");
    test_printint(matches[0]);
    TEST_ASSERT(count == 1);
    TEST_ASSERT(matches[0] == 10);
    test_printstr(" OK\n");

    // Test 2: Multiple occurrences (overlapping)
    const char *text2 = "ABABABA";
    const char *pattern2 = "ABA";
    count = simple_search(text2, str_len(text2), pattern2, str_len(pattern2), matches, 32);
    test_printstr("  multi: ");
    test_printint(count);
    test_printstr(" at ");
    test_printint(matches[0]);
    test_printstr(",");
    test_printint(matches[1]);
    test_printstr(",");
    test_printint(matches[2]);
    TEST_ASSERT(count == 3);
    TEST_ASSERT(matches[0] == 0);
    TEST_ASSERT(matches[1] == 2);
    TEST_ASSERT(matches[2] == 4);
    test_printstr(" OK\n");

    // Test 3: No match
    const char *text3 = "ABCDEFGH";
    const char *pattern3 = "XYZ";
    count = simple_search(text3, str_len(text3), pattern3, str_len(pattern3), matches, 32);
    test_printstr("  none: ");
    TEST_ASSERT(count == 0);
    test_printstr("OK\n");

    // Test 4: Single char pattern
    const char *text4 = "AAAA";
    const char *pattern4 = "A";
    count = simple_search(text4, str_len(text4), pattern4, str_len(pattern4), matches, 32);
    test_printstr("  single: ");
    test_printint(count);
    test_printstr(" at ");
    test_printint(matches[0]);
    test_printstr(",");
    test_printint(matches[1]);
    test_printstr(",");
    test_printint(matches[2]);
    test_printstr(",");
    test_printint(matches[3]);
    TEST_ASSERT(count == 4);
    TEST_ASSERT(matches[0] == 0);
    TEST_ASSERT(matches[1] == 1);
    TEST_ASSERT(matches[2] == 2);
    TEST_ASSERT(matches[3] == 3);
    test_printstr(" OK\n");

    test_printstr("All KMP-like tests passed!\n");
    test_pass();
    return 0;
}
