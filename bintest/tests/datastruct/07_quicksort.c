// Quicksort Test
// Tests: Quicksort algorithm implementation
#include "test_syscall.h"

void swap(int *a, int *b) {
    int t = *a;
    *a = *b;
    *b = t;
}

int partition(int *arr, int low, int high) {
    int pivot = arr[high];
    int i = low - 1;
    
    for (int j = low; j < high; j++) {
        if (arr[j] <= pivot) {
            i++;
            swap(&arr[i], &arr[j]);
        }
    }
    swap(&arr[i + 1], &arr[high]);
    return i + 1;
}

void quicksort(int *arr, int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);
        quicksort(arr, low, pi - 1);
        quicksort(arr, pi + 1, high);
    }
}

int is_sorted(int *arr, int n) {
    for (int i = 0; i < n - 1; i++) {
        if (arr[i] > arr[i + 1]) return 0;
    }
    return 1;
}

int test_main(void) {
    test_printstr("Testing Quicksort...\n");
    
    // Test 1: Simple array
    int arr1[] = {5, 2, 8, 1, 9};
    quicksort(arr1, 0, 4);
    
    test_printstr("  simple: ");
    TEST_ASSERT(is_sorted(arr1, 5));
    test_printstr("OK\n");
    
    // Test 2: Already sorted
    int arr2[] = {1, 2, 3, 4, 5};
    quicksort(arr2, 0, 4);
    
    test_printstr("  sorted: ");
    TEST_ASSERT(is_sorted(arr2, 5));
    test_printstr("OK\n");
    
    // Test 3: Reverse sorted
    int arr3[] = {5, 4, 3, 2, 1};
    quicksort(arr3, 0, 4);
    
    test_printstr("  reverse: ");
    TEST_ASSERT(is_sorted(arr3, 5));
    test_printstr("OK\n");
    
    // Test 4: Single element
    int arr4[] = {42};
    quicksort(arr4, 0, 0);
    
    test_printstr("  single: ");
    TEST_ASSERT(arr4[0] == 42);
    test_printstr("OK\n");
    
    // Test 5: With duplicates
    int arr5[] = {3, 1, 4, 1, 5, 9, 2, 6, 5, 3};
    quicksort(arr5, 0, 9);
    
    test_printstr("  dupes: ");
    TEST_ASSERT(is_sorted(arr5, 10));
    test_printstr("OK\n");
    
    // Test 6: Random-ish data
    int arr6[20];
    for (int i = 0; i < 20; i++) {
        arr6[i] = (i * 17 + 13) % 20;
    }
    quicksort(arr6, 0, 19);
    
    test_printstr("  random: ");
    TEST_ASSERT(is_sorted(arr6, 20));
    test_printstr("OK\n");
    
    test_printstr("All Quicksort tests passed!\n");
    test_pass();
    return 0;
}
