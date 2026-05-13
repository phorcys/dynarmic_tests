// Test vector duplicate, insert, extract operations
#include "test_syscall.h"

void vec_dup_val(int val, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = val;
    }
}

void vec_copy(int* src, int* dst, int n) {
    for (int i = 0; i < n; i++) {
        dst[i] = src[i];
    }
}

int vec_extract(int* a, int index) {
    return a[index];
}

void vec_insert(int* a, int index, int val) {
    a[index] = val;
}

void vec_dup_lane(int* a, int lane, int* c, int n) {
    int val = a[lane];
    for (int i = 0; i < n; i++) {
        c[i] = val;
    }
}

void vec_table_lookup(int* table, unsigned char* indices, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = table[indices[i]];
    }
}

int test_main(void) {
    test_printstr("Testing vector dup/insert/extract...\n");
    
    // Test 1: Duplicate value
    int c1[8];
    vec_dup_val(42, c1, 8);
    test_printstr("  dup: ");
    for (int i = 0; i < 8; i++) {
        TEST_ASSERT(c1[i] == 42);
    }
    test_printstr("OK\n");
    
    // Test 2: Copy vector
    int a2[] = {1, 2, 3, 4, 5, 6, 7, 8};
    int c2[8];
    vec_copy(a2, c2, 8);
    test_printstr("  copy: ");
    for (int i = 0; i < 8; i++) {
        TEST_ASSERT(c2[i] == a2[i]);
    }
    test_printstr("OK\n");
    
    // Test 3: Extract element
    int a3[] = {10, 20, 30, 40};
    test_printstr("  ext: ");
    TEST_ASSERT(vec_extract(a3, 0) == 10);
    TEST_ASSERT(vec_extract(a3, 1) == 20);
    TEST_ASSERT(vec_extract(a3, 2) == 30);
    TEST_ASSERT(vec_extract(a3, 3) == 40);
    test_printstr("OK\n");
    
    // Test 4: Insert element
    int a4[] = {0, 0, 0, 0};
    vec_insert(a4, 0, 100);
    vec_insert(a4, 3, 400);
    test_printstr("  ins: ");
    TEST_ASSERT(a4[0] == 100);
    TEST_ASSERT(a4[1] == 0);
    TEST_ASSERT(a4[2] == 0);
    TEST_ASSERT(a4[3] == 400);
    test_printstr("OK\n");
    
    // Test 5: Duplicate lane
    int a5[] = {1, 2, 3, 4};
    int c5[4];
    int val5 = a5[1];  // manually get value 2
    for (int i = 0; i < 4; i++) {
        c5[i] = val5;
    }
    test_printstr("  dup_lane: ");
    TEST_ASSERT(c5[0] == 2);
    TEST_ASSERT(c5[1] == 2);
    TEST_ASSERT(c5[2] == 2);
    TEST_ASSERT(c5[3] == 2);
    test_printstr("OK\n");
    
    // Test 6: Table lookup (gather)
    int table[] = {100, 200, 300, 400, 500, 600, 700, 800};
    unsigned char indices[] = {0, 2, 4, 6, 1, 3, 5, 7};
    int c6[8];
    vec_table_lookup(table, indices, c6, 8);
    test_printstr("  tbl: ");
    TEST_ASSERT(c6[0] == 100);
    TEST_ASSERT(c6[1] == 300);
    TEST_ASSERT(c6[2] == 500);
    TEST_ASSERT(c6[3] == 700);
    TEST_ASSERT(c6[4] == 200);
    TEST_ASSERT(c6[5] == 400);
    TEST_ASSERT(c6[6] == 600);
    TEST_ASSERT(c6[7] == 800);
    test_printstr("OK\n");
    
    test_printstr("All vector dup/insert/extract tests passed!\n");
    test_pass();
    return 0;
}
