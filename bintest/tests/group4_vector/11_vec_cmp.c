// Test vector comparison operations
#include "test_syscall.h"

void vec_cmp_eq(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (a[i] == b[i]) ? -1 : 0;
    }
}

void vec_cmp_gt(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (a[i] > b[i]) ? -1 : 0;
    }
}

void vec_cmp_lt(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (a[i] < b[i]) ? -1 : 0;
    }
}

void vec_cmp_ge(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (a[i] >= b[i]) ? -1 : 0;
    }
}

void vec_select(int* a, int* b, int* mask, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (mask[i] < 0) ? a[i] : b[i];
    }
}

int test_main(void) {
    test_printstr("Testing vector comparisons...\n");
    
    // Test 1: Equal
    int a1[] = {1, 2, 3, 4};
    int b1[] = {1, 3, 3, 5};
    int c1[4];
    vec_cmp_eq(a1, b1, c1, 4);
    test_printstr("  eq: ");
    TEST_ASSERT(c1[0] == -1);  // 1 == 1
    TEST_ASSERT(c1[1] == 0);   // 2 != 3
    TEST_ASSERT(c1[2] == -1);  // 3 == 3
    TEST_ASSERT(c1[3] == 0);   // 4 != 5
    test_printstr("OK\n");
    
    // Test 2: Greater than
    int a2[] = {5, 3, 4, 2};
    int b2[] = {3, 3, 5, 2};
    int c2[4];
    vec_cmp_gt(a2, b2, c2, 4);
    test_printstr("  gt: ");
    TEST_ASSERT(c2[0] == -1);  // 5 > 3
    TEST_ASSERT(c2[1] == 0);   // 3 !> 3
    TEST_ASSERT(c2[2] == 0);   // 4 !> 5
    TEST_ASSERT(c2[3] == 0);   // 2 !> 2
    test_printstr("OK\n");
    
    // Test 3: Less than
    int c3[4];
    vec_cmp_lt(a2, b2, c3, 4);
    test_printstr("  lt: ");
    TEST_ASSERT(c3[0] == 0);   // 5 !< 3
    TEST_ASSERT(c3[1] == 0);   // 3 !< 3
    TEST_ASSERT(c3[2] == -1);  // 4 < 5
    TEST_ASSERT(c3[3] == 0);   // 2 !< 2
    test_printstr("OK\n");
    
    // Test 4: Greater or equal
    int c4[4];
    vec_cmp_ge(a2, b2, c4, 4);
    test_printstr("  ge: ");
    TEST_ASSERT(c4[0] == -1);  // 5 >= 3
    TEST_ASSERT(c4[1] == -1);  // 3 >= 3
    TEST_ASSERT(c4[2] == 0);   // 4 !>= 5
    TEST_ASSERT(c4[3] == -1);  // 2 >= 2
    test_printstr("OK\n");
    
    // Test 5: Select based on mask
    int a5[] = {10, 20, 30, 40};
    int b5[] = {100, 200, 300, 400};
    int mask[] = {-1, 0, -1, 0};  // select from a for -1, from b for 0
    int c5[4];
    vec_select(a5, b5, mask, c5, 4);
    test_printstr("  select: ");
    TEST_ASSERT(c5[0] == 10);   // mask=-1, select a
    TEST_ASSERT(c5[1] == 200);  // mask=0, select b
    TEST_ASSERT(c5[2] == 30);   // mask=-1, select a
    TEST_ASSERT(c5[3] == 400);  // mask=0, select b
    test_printstr("OK\n");
    
    test_printstr("All vector comparison tests passed!\n");
    test_pass();
    return 0;
}
