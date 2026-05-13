// Test binary search algorithm
#include "test_syscall.h"

int binary_search(int* arr, int n, int target) {
    int left = 0, right = n - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] == target) return mid;
        if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1;
}

int test_main(void) {
    test_printstr("Testing binary search...\n");
    
    // Test 1: Find existing element
    int arr[] = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19};
    int idx = binary_search(arr, 10, 7);
    test_printstr("  find(7): index ");
    test_printint(idx);
    TEST_ASSERT(idx == 3);
    
    // Test 2: Find first element
    idx = binary_search(arr, 10, 1);
    test_printstr("\n  find(1): index ");
    test_printint(idx);
    TEST_ASSERT(idx == 0);
    
    // Test 3: Find last element
    idx = binary_search(arr, 10, 19);
    test_printstr("\n  find(19): index ");
    test_printint(idx);
    TEST_ASSERT(idx == 9);
    
    // Test 4: Element not found
    idx = binary_search(arr, 10, 8);
    test_printstr("\n  find(8): index ");
    test_printint(idx);
    TEST_ASSERT(idx == -1);
    
    // Test 5: Small array
    int small[] = {42};
    idx = binary_search(small, 1, 42);
    test_printstr("\n  small[0]=42: index ");
    test_printint(idx);
    TEST_ASSERT(idx == 0);
    
    // Test 6: Not in small array
    idx = binary_search(small, 1, 41);
    TEST_ASSERT(idx == -1);
    
    test_printstr("\nAll binary search tests passed!\n");
    test_pass();
    return 0;
}
