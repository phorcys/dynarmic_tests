// Test bubble sort algorithm
#include "test_syscall.h"

void bubble_sort(int* arr, int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - 1 - i; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

int is_sorted(int* arr, int n) {
    for (int i = 1; i < n; i++) {
        if (arr[i] < arr[i - 1]) return 0;
    }
    return 1;
}

int test_main(void) {
    test_printstr("Testing bubble sort...\n");
    
    // Test 1: Simple array
    int arr1[] = {5, 2, 8, 1, 9, 3};
    bubble_sort(arr1, 6);
    test_printstr("  sorted: ");
    for (int i = 0; i < 6; i++) {
        test_printint(arr1[i]);
        test_printstr(" ");
    }
    TEST_ASSERT(is_sorted(arr1, 6));
    TEST_ASSERT(arr1[0] == 1);
    TEST_ASSERT(arr1[5] == 9);
    
    test_printstr("\nAll bubble sort tests passed!\n");
    test_pass();
    return 0;
}
