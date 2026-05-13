// Test simple sorting (non-recursive heap operations)
#include "test_syscall.h"

void swap(int* a, int* b) {
    int t = *a;
    *a = *b;
    *b = t;
}

// Simple selection sort (no recursion)
void selection_sort(int* arr, int n) {
    for (int i = 0; i < n - 1; i++) {
        int min_idx = i;
        for (int j = i + 1; j < n; j++) {
            if (arr[j] < arr[min_idx]) {
                min_idx = j;
            }
        }
        if (min_idx != i) {
            swap(&arr[i], &arr[min_idx]);
        }
    }
}

int test_main(void) {
    test_printstr("Testing sorting...\n");
    
    // Test 1: Small array
    int arr1[] = {4, 3, 2, 1};
    selection_sort(arr1, 4);
    test_printstr("  sort: ");
    TEST_ASSERT(arr1[0] == 1);
    TEST_ASSERT(arr1[1] == 2);
    TEST_ASSERT(arr1[2] == 3);
    TEST_ASSERT(arr1[3] == 4);
    test_printstr("OK\n");
    
    test_printstr("All sorting tests passed!\n");
    test_pass();
    return 0;
}
