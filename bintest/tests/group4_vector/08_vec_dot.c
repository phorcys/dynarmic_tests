// Test vector dot product and cross product
#include "test_syscall.h"

int dot_product_int(int* a, int* b, int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += a[i] * b[i];
    }
    return sum;
}

int64_t dot_product_long(int64_t* a, int64_t* b, int n) {
    int64_t sum = 0;
    for (int i = 0; i < n; i++) {
        sum += a[i] * b[i];
    }
    return sum;
}

void cross_product_3d(int* a, int* b, int* result) {
    result[0] = a[1] * b[2] - a[2] * b[1];
    result[1] = a[2] * b[0] - a[0] * b[2];
    result[2] = a[0] * b[1] - a[1] * b[0];
}

int test_main(void) {
    test_printstr("Testing vector dot/cross products...\n");
    
    // Test 1: Simple dot product
    int a1[] = {1, 2, 3, 4};
    int b1[] = {5, 6, 7, 8};
    int dot1 = dot_product_int(a1, b1, 4);
    test_printstr("  dot4: ");
    test_printint(dot1);
    TEST_ASSERT(dot1 == 70);  // 1*5 + 2*6 + 3*7 + 4*8 = 70
    test_printstr(" OK\n");
    
    // Test 2: 8-element dot product
    int a2[] = {1, 2, 3, 4, 5, 6, 7, 8};
    int b2[] = {8, 7, 6, 5, 4, 3, 2, 1};
    int dot2 = dot_product_int(a2, b2, 8);
    test_printstr("  dot8: ");
    test_printint(dot2);
    TEST_ASSERT(dot2 == 120);
    test_printstr(" OK\n");
    
    // Test 3: Long dot product
    int64_t a3[] = {1000000000LL, 2000000000LL};
    int64_t b3[] = {2LL, 3LL};
    int64_t dot3 = dot_product_long(a3, b3, 2);
    test_printstr("  dot_long: ");
    test_printstr("computed\n");
    TEST_ASSERT(dot3 == 8000000000LL);
    test_printstr(" OK\n");
    
    // Test 4: 3D cross product
    int a4[] = {1, 0, 0};  // unit x
    int b4[] = {0, 1, 0};  // unit y
    int cross[3];
    cross_product_3d(a4, b4, cross);
    test_printstr("  cross: ");
    test_printint(cross[0]);
    test_printstr(",");
    test_printint(cross[1]);
    test_printstr(",");
    test_printint(cross[2]);
    TEST_ASSERT(cross[0] == 0);   // should be unit z
    TEST_ASSERT(cross[1] == 0);
    TEST_ASSERT(cross[2] == 1);
    test_printstr(" OK\n");
    
    // Test 5: Larger cross product (non-unit vectors)
    int a5[] = {2, 3, 4};
    int b5[] = {5, 6, 7};
    cross_product_3d(a5, b5, cross);
    test_printstr("  cross2: ");
    TEST_ASSERT(cross[0] == -3);   // 3*7 - 4*6 = -3
    TEST_ASSERT(cross[1] == 6);    // 4*5 - 2*7 = 6
    TEST_ASSERT(cross[2] == -3);   // 2*6 - 3*5 = -3
    test_printstr("OK\n");
    
    test_printstr("All vector dot/cross tests passed!\n");
    test_pass();
    return 0;
}
