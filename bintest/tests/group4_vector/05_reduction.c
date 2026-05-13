// Test reduction operations
#include "test_syscall.h"

int reduce_sum(int* arr, int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += arr[i];
    }
    return sum;
}

int reduce_max(int* arr, int n) {
    int max = arr[0];
    for (int i = 1; i < n; i++) {
        if (arr[i] > max) max = arr[i];
    }
    return max;
}

int reduce_min(int* arr, int n) {
    int min = arr[0];
    for (int i = 1; i < n; i++) {
        if (arr[i] < min) min = arr[i];
    }
    return min;
}

int test_main(void) {
    test_printstr("Testing reduction operations...\n");
    
    int arr[] = {3, 1, 4, 1, 5, 9, 2, 6};
    int n = 8;
    
    // Test 1: Sum reduction
    int sum = reduce_sum(arr, n);
    test_printstr("  sum: ");
    test_printint(sum);
    TEST_ASSERT(sum == 31);
    
    // Test 2: Max reduction
    int max = reduce_max(arr, n);
    test_printstr("\n  max: ");
    test_printint(max);
    TEST_ASSERT(max == 9);
    
    // Test 3: Min reduction
    int min = reduce_min(arr, n);
    test_printstr("\n  min: ");
    test_printint(min);
    TEST_ASSERT(min == 1);
    
    test_printstr("\nAll reduction tests passed!\n");
    test_pass();
    return 0;
}
