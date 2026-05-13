// Test string operations
#include "test_syscall.h"

int str_len(const char* s) {
    int len = 0;
    while (s[len]) len++;
    return len;
}

void str_copy(char* dst, const char* src) {
    while (*src) {
        *dst++ = *src++;
    }
    *dst = '\0';
}

int str_cmp(const char* a, const char* b) {
    while (*a && *b && *a == *b) {
        a++;
        b++;
    }
    return *(unsigned char*)a - *(unsigned char*)b;
}

void str_cat(char* dst, const char* src) {
    while (*dst) dst++;
    while (*src) {
        *dst++ = *src++;
    }
    *dst = '\0';
}

void str_reverse(char* s) {
    int len = str_len(s);
    for (int i = 0; i < len / 2; i++) {
        char temp = s[i];
        s[i] = s[len - 1 - i];
        s[len - 1 - i] = temp;
    }
}

int str_find(const char* s, char c) {
    for (int i = 0; s[i]; i++) {
        if (s[i] == c) return i;
    }
    return -1;
}

int test_main(void) {
    test_printstr("Testing string operations...\n");
    
    // Test 1: String length
    int len = str_len("Hello");
    test_printstr("  len(\"Hello\"): ");
    test_printint(len);
    TEST_ASSERT(len == 5);
    
    // Test 2: String copy
    char buf[20];
    str_copy(buf, "World");
    test_printstr("\n  copy: ");
    test_printstr(buf);
    TEST_ASSERT(str_cmp(buf, "World") == 0);
    
    // Test 3: String compare
    int cmp1 = str_cmp("apple", "apple");
    int cmp2 = str_cmp("apple", "apricot");
    test_printstr("\n  cmp(equal): ");
    test_printint(cmp1);
    test_printstr(", cmp(diff): ");
    test_printint(cmp2);
    TEST_ASSERT(cmp1 == 0 && cmp2 < 0);
    
    // Test 4: String concatenate
    char cat[20] = "Hello";
    str_cat(cat, " World");
    test_printstr("\n  cat: ");
    test_printstr(cat);
    TEST_ASSERT(str_cmp(cat, "Hello World") == 0);
    
    // Test 5: String reverse
    char rev[] = "abcdef";
    str_reverse(rev);
    test_printstr("\n  reverse: ");
    test_printstr(rev);
    TEST_ASSERT(str_cmp(rev, "fedcba") == 0);
    
    // Test 6: String find
    int pos = str_find("Hello", 'l');
    test_printstr("\n  find('l'): ");
    test_printint(pos);
    TEST_ASSERT(pos == 2);
    
    pos = str_find("Hello", 'z');
    test_printstr("\n  find('z'): ");
    test_printint(pos);
    TEST_ASSERT(pos == -1);
    
    test_printstr("\nAll string tests passed!\n");
    test_pass();
    return 0;
}
