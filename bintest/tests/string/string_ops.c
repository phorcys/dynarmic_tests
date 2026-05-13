/*
 * String Operations Test
 * Tests string manipulation patterns
 */

#include "test_syscall.h"

/* String length */
static int test_str_length(void) {
    test_printstr("Testing strlen...\n");
    
    const char *s = "Hello, World!";
    int len = 0;
    while (s[len] != '\0') {
        len++;
    }
    TEST_ASSERT(len == 13);
    
    s = "";
    len = 0;
    while (s[len] != '\0') {
        len++;
    }
    TEST_ASSERT(len == 0);
    
    test_printstr("  Strlen: PASS\n");
    return 0;
}

/* String copy */
static int test_strcpy(void) {
    test_printstr("Testing strcpy...\n");
    
    const char *src = "Copy this";
    char dst[20];
    
    int i = 0;
    do {
        dst[i] = src[i];
    } while (src[i++] != '\0');
    
    TEST_ASSERT(dst[0] == 'C');
    TEST_ASSERT(dst[4] == ' ');
    TEST_ASSERT(dst[8] == 's');
    TEST_ASSERT(dst[9] == '\0');
    
    test_printstr("  Strcpy: PASS\n");
    return 0;
}

/* String compare */
static int test_strcmp(void) {
    test_printstr("Testing strcmp...\n");
    
    const char *a = "apple";
    const char *b = "apple";
    const char *c = "banana";
    
    /* Compare a and b (equal) */
    int result = 0;
    for (int i = 0; a[i] || b[i]; i++) {
        if (a[i] != b[i]) {
            result = a[i] - b[i];
            break;
        }
    }
    TEST_ASSERT(result == 0);
    
    /* Compare a and c (not equal) */
    result = a[0] - c[0];  /* 'a' - 'b' = -1 */
    TEST_ASSERT(result < 0);
    
    test_printstr("  Strcmp: PASS\n");
    return 0;
}

/* String concatenate */
static int test_strcat(void) {
    test_printstr("Testing strcat...\n");
    
    char buf[30] = "Hello";
    const char *add = " World";
    
    int dst_end = 0;
    while (buf[dst_end] != '\0') dst_end++;
    
    int i = 0;
    do {
        buf[dst_end + i] = add[i];
    } while (add[i++] != '\0');
    
    TEST_ASSERT(buf[5] == ' ');
    TEST_ASSERT(buf[6] == 'W');
    TEST_ASSERT(buf[10] == 'd');
    TEST_ASSERT(buf[11] == '\0');
    
    test_printstr("  Strcat: PASS\n");
    return 0;
}

/* Character search */
static int test_strchr(void) {
    test_printstr("Testing strchr...\n");
    
    const char *s = "Hello, World!";
    
    /* Find 'W' */
    int pos = -1;
    for (int i = 0; s[i]; i++) {
        if (s[i] == 'W') {
            pos = i;
            break;
        }
    }
    TEST_ASSERT(pos == 7);
    
    /* Find 'z' (not found) */
    pos = -1;
    for (int i = 0; s[i]; i++) {
        if (s[i] == 'z') {
            pos = i;
            break;
        }
    }
    TEST_ASSERT(pos == -1);
    
    test_printstr("  Strchr: PASS\n");
    return 0;
}

/* Memory set */
static int test_memset(void) {
    test_printstr("Testing memset...\n");
    
    char buf[16];
    
    /* Fill with 'A' */
    for (int i = 0; i < 16; i++) {
        buf[i] = 'A';
    }
    
    TEST_ASSERT(buf[0] == 'A');
    TEST_ASSERT(buf[15] == 'A');
    
    test_printstr("  Memset: PASS\n");
    return 0;
}

/* Memory copy */
static int test_memcpy(void) {
    test_printstr("Testing memcpy...\n");
    
    char src[8] = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' };
    char dst[8];
    
    for (int i = 0; i < 8; i++) {
        dst[i] = src[i];
    }
    
    TEST_ASSERT(dst[0] == 'A');
    TEST_ASSERT(dst[7] == 'H');
    
    test_printstr("  Memcpy: PASS\n");
    return 0;
}

/* Case conversion */
static int test_case(void) {
    test_printstr("Testing case conv...\n");
    
    char upper[] = "HELLO";
    char lower[6];
    
    for (int i = 0; upper[i]; i++) {
        lower[i] = upper[i] + 32;  /* ASCII offset */
    }
    lower[5] = '\0';
    
    TEST_ASSERT(lower[0] == 'h');
    TEST_ASSERT(lower[4] == 'o');
    
    test_printstr("  Case conv: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== String Operations Tests ===\n");
    
    test_str_length();
    test_strcpy();
    test_strcmp();
    test_strcat();
    test_strchr();
    test_memset();
    test_memcpy();
    test_case();
    
    test_printstr("All string operation tests passed!\n");
    test_pass();
    return 0;
}
