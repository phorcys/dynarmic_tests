/*
 * Memory Operations Test
 * Tests various memory access patterns
 */

#include "test_syscall.h"

/* Global test buffers */
static char g_src[20];
static char g_dst[20];

/* Simple memcpy */
static void my_memcpy(void *dst, const void *src, unsigned long n) {
    char *d = (char *)dst;
    const char *s = (const char *)src;
    for (unsigned long i = 0; i < n; i++) {
        d[i] = s[i];
    }
}

/* Simple memset */
static void my_memset(void *dst, int c, unsigned long n) {
    char *d = (char *)dst;
    for (unsigned long i = 0; i < n; i++) {
        d[i] = (char)c;
    }
}

/* Test memcpy */
static int test_memcpy(void) {
    test_printstr("Testing memcpy...\n");
    
    /* Initialize source */
    g_src[0] = 'H';
    g_src[1] = 'e';
    g_src[2] = 'l';
    g_src[3] = 'l';
    g_src[4] = 'o';
    g_src[5] = '\0';
    
    my_memcpy(g_dst, g_src, 6);
    TEST_ASSERT(g_dst[0] == 'H');
    TEST_ASSERT(g_dst[1] == 'e');
    TEST_ASSERT(g_dst[4] == 'o');
    
    test_printstr("  memcpy: PASS\n");
    return 0;
}

/* Test memset */
static int test_memset(void) {
    test_printstr("Testing memset...\n");
    
    my_memset(g_dst, 'X', 10);
    TEST_ASSERT(g_dst[0] == 'X');
    TEST_ASSERT(g_dst[9] == 'X');
    
    test_printstr("  memset: PASS\n");
    return 0;
}

/* Test array access patterns */
static int test_array_access(void) {
    test_printstr("Testing array access...\n");
    
    int64_t arr[10][10];
    
    /* Row-major access */
    int64_t count = 0;
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            arr[i][j] = count++;
        }
    }
    
    TEST_ASSERT(arr[0][0] == 0);
    TEST_ASSERT(arr[0][9] == 9);
    TEST_ASSERT(arr[1][0] == 10);
    TEST_ASSERT(arr[9][9] == 99);
    
    /* Column-major access (less cache-friendly) */
    count = 0;
    for (int j = 0; j < 10; j++) {
        for (int i = 0; i < 10; i++) {
            count += arr[i][j];
        }
    }
    TEST_ASSERT(count == 4950);  /* Sum of 0..99 */
    
    test_printstr("  Array access: PASS\n");
    return 0;
}

/* Test pointer arithmetic */
static int test_pointer_arith(void) {
    test_printstr("Testing pointer arith...\n");
    
    int64_t arr[] = {10, 20, 30, 40, 50};
    int64_t *p = arr;
    
    TEST_ASSERT(*p == 10);
    TEST_ASSERT(*(p + 1) == 20);
    TEST_ASSERT(*(p + 4) == 50);
    
    p += 2;
    TEST_ASSERT(*p == 30);
    
    p--;
    TEST_ASSERT(*p == 20);
    
    int64_t *end = arr + 5;
    TEST_ASSERT(end - arr == 5);
    TEST_ASSERT(end > arr);
    
    test_printstr("  Pointer arith: PASS\n");
    return 0;
}

/* Test unaligned access (if supported) */
static int test_unaligned_access(void) {
    test_printstr("Testing unaligned access...\n");
    
    /* Place a 64-bit value at an unaligned offset */
    char buf[16];
    int64_t *val = (int64_t *)(buf + 3);  /* Not 8-byte aligned */
    
    *val = 0x123456789ABCDEF0LL;
    TEST_ASSERT(*val == 0x123456789ABCDEF0LL);
    
    *val = -1;
    TEST_ASSERT(*val == -1);
    
    test_printstr("  Unaligned access: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Memory Operations Tests ===\n");
    
    test_memcpy();
    test_memset();
    test_array_access();
    test_pointer_arith();
    test_unaligned_access();
    
    test_printstr("All memory tests passed!\n");
    test_pass();
    return 0;
}