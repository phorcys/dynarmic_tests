// Test array-based float vector operations
#include "test_syscall.h"

void fvec_add(float* a, float* b, float* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

void fvec_scale(float* a, float s, float* b, int n) {
    for (int i = 0; i < n; i++) {
        b[i] = a[i] * s;
    }
}

float fvec_sum(float* a, int n) {
    float sum = 0;
    for (int i = 0; i < n; i++) {
        sum += a[i];
    }
    return sum;
}

int test_main(void) {
    test_printstr("Testing float vector operations...\n");
    
    float a[] = {1.0f, 2.0f, 3.0f, 4.0f};
    float b[] = {0.5f, 1.0f, 1.5f, 2.0f};
    float c[4];
    
    // Test 1: Float vector add
    fvec_add(a, b, c, 4);
    test_printstr("  fadd[0]: ");
    test_printint((int)c[0]);
    test_printstr(" [3]: ");
    test_printint((int)c[3]);
    TEST_ASSERT(c[0] == 1.5f && c[3] == 6.0f);
    
    // Test 2: Float vector scale
    fvec_scale(a, 2.0f, c, 4);
    test_printstr("\n  scale[0]: ");
    test_printint((int)c[0]);
    test_printstr(" [3]: ");
    test_printint((int)c[3]);
    TEST_ASSERT(c[0] == 2.0f && c[3] == 8.0f);
    
    // Test 3: Float sum
    float sum = fvec_sum(a, 4);
    test_printstr("\n  fsum: ");
    test_printint((int)sum);
    TEST_ASSERT(sum == 10.0f);
    
    test_printstr("\nAll float vector tests passed!\n");
    test_pass();
    return 0;
}
