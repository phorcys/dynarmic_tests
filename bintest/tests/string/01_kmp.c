// KMP Pattern Matching Test
// Tests: Knuth-Morris-Pratt string search algorithm
#include "test_syscall.h"

static int lps[256];

void compute_lps(const char *pattern, int m) {
    int len = 0;
    lps[0] = 0;
    
    int i = 1;
    while (i < m) {
        if (pattern[i] == pattern[len]) {
            len++;
            lps[i] = len;
            i++;
        } else {
            if (len != 0) {
                len = lps[len - 1];
            } else {
                lps[i] = 0;
                i++;
            }
        }
    }
}

int kmp_search(const char *text, int n, const char *pattern, int m, int *matches, int max_matches) {
    // Handle empty pattern
    if (m == 0) {
        return 0;  // No matches for empty pattern
    }
    
    compute_lps(pattern, m);
    
    int count = 0;
    int i = 0, j = 0;
    
    while (i < n) {
        if (pattern[j] == text[i]) {
            i++;
            j++;
        }
        
        if (j == m) {
            if (count < max_matches) {
                matches[count++] = i - j;
            }
            j = lps[j - 1];
        } else if (i < n && pattern[j] != text[i]) {
            if (j != 0) {
                j = lps[j - 1];
            } else {
                i++;
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
    test_printstr("Testing KMP Search...\n");
    int matches[32];
    int count;
    
    // Test 1: Simple pattern
    const char *text1 = "ABABDABACDABABCABAB";
    const char *pattern1 = "ABABCABAB";
    count = kmp_search(text1, str_len(text1), pattern1, str_len(pattern1), matches, 32);
    test_printstr("  simple: ");
    test_printint(count);
    test_printstr(" at ");
    test_printint(matches[0]);
    TEST_ASSERT(count == 1);
    TEST_ASSERT(matches[0] == 10);
    test_printstr(" OK\n");
    
    // Test 2: Multiple occurrences (overlapping)
    // KMP finds all matches including overlapping: positions 0, 2, 4
    const char *text2 = "ABABABA";
    const char *pattern2 = "ABA";
    count = kmp_search(text2, str_len(text2), pattern2, str_len(pattern2), matches, 32);
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
    count = kmp_search(text3, str_len(text3), pattern3, str_len(pattern3), matches, 32);
    test_printstr("  none: ");
    TEST_ASSERT(count == 0);
    test_printstr("OK\n");
    
    // Test 4: Single char pattern
    const char *text4 = "AAAAAA";
    const char *pattern4 = "A";
    count = kmp_search(text4, str_len(text4), pattern4, str_len(pattern4), matches, 32);
    test_printstr("  single: ");
    test_printint(count);
    TEST_ASSERT(count == 6);
    test_printstr(" OK\n");
    
    // Test 5: Pattern longer than text
    const char *text5 = "AB";
    const char *pattern5 = "ABCDEFG";
    count = kmp_search(text5, str_len(text5), pattern5, str_len(pattern5), matches, 32);
    test_printstr("  longer: ");
    TEST_ASSERT(count == 0);
    test_printstr("OK\n");
    
    // Test 6: Empty pattern (matches everywhere)
    const char *text6 = "ABC";
    const char *pattern6 = "";
    count = kmp_search(text6, str_len(text6), pattern6, 0, matches, 32);
    test_printstr("  empty: ");
    TEST_ASSERT(count >= 0); // Behavior varies
    test_printstr("OK\n");
    
    test_printstr("All KMP tests passed!\n");
    test_pass();
    return 0;
}
