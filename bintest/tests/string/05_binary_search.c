// Binary Search Test
// Tests: Binary search algorithm
#include "test_syscall.h"

int binary_search(int *arr, int n, int target) {
    int left = 0;
    int right = n - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (arr[mid] == target) {
            return mid;
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    
    return -1;
}

int test_main(void) {
    test_printstr("Testing Binary Search...\n");
    
    // Test 1: Find existing element
    int arr1[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    
    test_printstr("  find: ");
    TEST_ASSERT(binary_search(arr1, 10, 5) == 4);
    TEST_ASSERT(binary_search(arr1, 10, 1) == 0);
    TEST_ASSERT(binary_search(arr1, 10, 10) == 9);
    test_printstr("OK\n");
    
    // Test 2: Find non-existing
    test_printstr("  notfind: ");
    TEST_ASSERT(binary_search(arr1, 10, 11) == -1);
    TEST_ASSERT(binary_search(arr1, 10, 0) == -1);
    TEST_ASSERT(binary_search(arr1, 10, -5) == -1);
    test_printstr("OK\n");
    
    // Test 3: Single element
    int arr2[] = {42};
    
    test_printstr("  single: ");
    TEST_ASSERT(binary_search(arr2, 1, 42) == 0);
    TEST_ASSERT(binary_search(arr2, 1, 41) == -1);
    test_printstr("OK\n");
    
    // Test 4: Two elements
    int arr3[] = {1, 2};
    
    test_printstr("  two: ");
    TEST_ASSERT(binary_search(arr3, 2, 1) == 0);
    TEST_ASSERT(binary_search(arr3, 2, 2) == 1);
    TEST_ASSERT(binary_search(arr3, 2, 3) == -1);
    test_printstr("OK\n");
    
    // Test 5: Large array
    int arr4[100];
    for (int i = 0; i < 100; i++) arr4[i] = i * 2;  // 0, 2, 4, ..., 198
    
    test_printstr("  large: ");
    TEST_ASSERT(binary_search(arr4, 100, 50) == 25);
    TEST_ASSERT(binary_search(arr4, 100, 198) == 99);
    TEST_ASSERT(binary_search(arr4, 100, 51) == -1);  // Odd numbers not in array
    test_printstr("OK\n");
    
    // Test 6: Duplicates (finds one of them)
    int arr5[] = {1, 2, 2, 2, 3};
    
    test_printstr("  dup: ");
    int idx = binary_search(arr5, 5, 2);
    TEST_ASSERT(idx >= 1 && idx <= 3);  // Any of the 2's
    test_printstr("OK\n");
    
    test_printstr("All Binary Search tests passed!\n");
    test_pass();
    return 0;
}
