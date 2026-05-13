// Simple Wildcard Pattern Matching Test
// Tests: Pattern matching with ? and * wildcards
#include "test_syscall.h"

// Returns 1 if string matches pattern
// ? matches single character
// * matches zero or more characters
int wildcard_match(const char *pattern, const char *str) {
    // Pointers for backtracking
    const char *star = 0;
    const char *star_str = 0;
    
    while (*str) {
        if (*pattern == *str || *pattern == '?') {
            pattern++;
            str++;
        } else if (*pattern == '*') {
            star = pattern++;
            star_str = str;
        } else if (star) {
            pattern = star + 1;
            str = ++star_str;
        } else {
            return 0;
        }
    }
    
    // Skip trailing stars
    while (*pattern == '*') pattern++;
    
    return *pattern == '\0';
}

int test_main(void) {
    test_printstr("Testing Wildcard Match...\n");
    
    // Test 1: Exact match
    test_printstr("  exact: ");
    TEST_ASSERT(wildcard_match("hello", "hello"));
    TEST_ASSERT(!wildcard_match("hello", "world"));
    test_printstr("OK\n");
    
    // Test 2: Question mark
    test_printstr("  question: ");
    TEST_ASSERT(wildcard_match("h?llo", "hello"));
    TEST_ASSERT(wildcard_match("h?llo", "hallo"));
    TEST_ASSERT(!wildcard_match("h?llo", "hllo"));
    test_printstr("OK\n");
    
    // Test 3: Star
    test_printstr("  star: ");
    TEST_ASSERT(wildcard_match("h*", "hello"));
    TEST_ASSERT(wildcard_match("*o", "hello"));
    TEST_ASSERT(wildcard_match("h*o", "hello"));
    TEST_ASSERT(wildcard_match("*", "anything"));
    TEST_ASSERT(wildcard_match("*", ""));
    test_printstr("OK\n");
    
    // Test 4: Combined
    test_printstr("  combined: ");
    TEST_ASSERT(wildcard_match("*.c", "test.c"));
    TEST_ASSERT(wildcard_match("*.c", "main.c"));
    TEST_ASSERT(!wildcard_match("*.c", "test.cpp"));
    TEST_ASSERT(wildcard_match("test?.c", "test1.c"));
    TEST_ASSERT(wildcard_match("test?.c", "test2.c"));
    test_printstr("OK\n");
    
    // Test 5: Multiple stars
    test_printstr("  multistar: ");
    TEST_ASSERT(wildcard_match("*.*", "file.txt"));
    TEST_ASSERT(wildcard_match("*.*", "a.b"));
    TEST_ASSERT(wildcard_match("a*b*c", "abc"));
    TEST_ASSERT(wildcard_match("a*b*c", "aXXbYYc"));
    test_printstr("OK\n");
    
    // Test 6: Edge cases
    test_printstr("  edge: ");
    TEST_ASSERT(wildcard_match("", ""));
    TEST_ASSERT(!wildcard_match("a", ""));
    TEST_ASSERT(wildcard_match("*", ""));
    TEST_ASSERT(wildcard_match("?", "a"));
    TEST_ASSERT(!wildcard_match("?", ""));
    test_printstr("OK\n");
    
    test_printstr("All Wildcard tests passed!\n");
    test_pass();
    return 0;
}
