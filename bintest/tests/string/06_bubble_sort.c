// Bubble Sort Test
// Tests: Bubble sort algorithm
#include "test_syscall.h"

void bubble_sort(int *arr, int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

int is_sorted(int *arr, int n) {
    for (int i = 0; i < n - 1; i++) {
        if (arr[i] > arr[i + 1]) return 0;
    }
    return 1;
}

int test_main(void) {
    test_printstr("Testing Bubble Sort...\n");
    
    // Test 1: Simple array
    int arr1[] = {5, 2, 8, 1, 9, 3};
    bubble_sort(arr1, 6);
    
    test_printstr("  simple: ");
    TEST_ASSERT(is_sorted(arr1, 6));
    test_printstr("OK\n");
    
    // Test 2: Already sorted
    int arr2[] = {1, 2, 3, 4, 5};
    bubble_sort(arr2, 5);
    
    test_printstr("  sorted: ");
    TEST_ASSERT(is_sorted(arr2, 5));
    test_printstr("OK\n");
    
    // Test 3: Reverse sorted
    int arr3[] = {5, 4, 3, 2, 1};
    bubble_sort(arr3, 5);
    
    test_printstr("  reverse: ");
    TEST_ASSERT(is_sorted(arr3, 5));
    test_printstr("OK\n");
    
    // Test 4: Duplicates
    int arr4[] = {3, 1, 2, 1, 3, 2};
    bubble_sort(arr4, 6);
    
    test_printstr("  dupes: ");
    TEST_ASSERT(is_sorted(arr4, 6));
    test_printstr("OK\n");
    
    // Test 5: Two elements
    int arr5[] = {2, 1};
    bubble_sort(arr5, 2);
    
    test_printstr("  two: ");
    TEST_ASSERT(arr5[0] == 1 && arr5[1] == 2);
    test_printstr("OK\n");
    
    // Test 6: Single element
    int arr6[] = {42};
    bubble_sort(arr6, 1);
    
    test_printstr("  single: ");
    TEST_ASSERT(arr6[0] == 42);
    test_printstr("OK\n");
    
    test_printstr("All Bubble Sort tests passed!\n");
    test_pass();
    return 0;
}
