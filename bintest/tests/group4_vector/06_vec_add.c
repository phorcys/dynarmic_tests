// Test vector addition operations
#include "test_syscall.h"

void vec_add_int(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

void vec_sub_int(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] - b[i];
    }
}

void vec_add_long(int64_t* a, int64_t* b, int64_t* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

int test_main(void) {
    test_printstr("Testing vector addition...\n");
    
    // Test 1: Integer vector addition
    int a1[] = {1, 2, 3, 4, 5, 6, 7, 8};
    int b1[] = {8, 7, 6, 5, 4, 3, 2, 1};
    int c1[8];
    vec_add_int(a1, b1, c1, 8);
    test_printstr("  add: ");
    for (int i = 0; i < 8; i++) {
        TEST_ASSERT(c1[i] == 9);
    }
    test_printstr("OK\n");
    
    // Test 2: Integer vector subtraction
    int c2[8];
    vec_sub_int(a1, b1, c2, 8);
    test_printstr("  sub: ");
    for (int i = 0; i < 8; i++) {
        TEST_ASSERT(c2[i] == a1[i] - b1[i]);
    }
    test_printstr("OK\n");
    
    // Test 3: Long vector addition
    int64_t a3[] = {1000000000LL, 2000000000LL, 3000000000LL, 4000000000LL};
    int64_t b3[] = {500000000LL, 600000000LL, 700000000LL, 800000000LL};
    int64_t c3[4];
    vec_add_long(a3, b3, c3, 4);
    test_printstr("  long_add: ");
    TEST_ASSERT(c3[0] == 1500000000LL);
    TEST_ASSERT(c3[1] == 2600000000LL);
    TEST_ASSERT(c3[2] == 3700000000LL);
    TEST_ASSERT(c3[3] == 4800000000LL);
    test_printstr("OK\n");
    
    // Test 4: Medium array (simplified)
    int med_a[8];
    int med_b[8];
    int med_c[8];
    for (int i = 0; i < 8; i++) {
        med_a[i] = i;
        med_b[i] = i * 2;
    }
    vec_add_int(med_a, med_b, med_c, 8);
    test_printstr("  medium: ");
    TEST_ASSERT(med_c[0] == 0);
    TEST_ASSERT(med_c[1] == 3);
    TEST_ASSERT(med_c[7] == 21);
    test_printstr("OK\n");
    
    test_printstr("All vector addition tests passed!\n");
    test_pass();
    return 0;
}
