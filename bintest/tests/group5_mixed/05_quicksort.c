// Test simple sorting algorithm
#include "test_syscall.h"

void swap(int* a, int* b) {
    int t = *a;
    *a = *b;
    *b = t;
}

// Simple bubble sort (very simple, no issues)
void bubble_sort(int* arr, int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                swap(&arr[j], &arr[j + 1]);
            }
        }
    }
}

int test_main(void) {
    test_printstr("Testing bubble sort...\n");
    
    // Test 1: Small array
    int arr1[] = {5, 2, 8, 1};
    bubble_sort(arr1, 4);
    test_printstr("  sort: ");
    TEST_ASSERT(arr1[0] == 1);
    TEST_ASSERT(arr1[1] == 2);
    TEST_ASSERT(arr1[2] == 5);
    TEST_ASSERT(arr1[3] == 8);
    test_printstr("OK\n");
    
    test_printstr("All sort tests passed!\n");
    test_pass();
    return 0;
}
