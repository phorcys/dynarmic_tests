// Test array operations with functions
#include "test_syscall.h"

int array_sum(int* arr, int len) {
    int sum = 0;
    for (int i = 0; i < len; i++) {
        sum += arr[i];
    }
    return sum;
}

int array_max(int* arr, int len) {
    int max = arr[0];
    for (int i = 1; i < len; i++) {
        if (arr[i] > max) max = arr[i];
    }
    return max;
}

void array_reverse(int* arr, int len) {
    for (int i = 0; i < len / 2; i++) {
        int temp = arr[i];
        arr[i] = arr[len - 1 - i];
        arr[len - 1 - i] = temp;
    }
}

int test_main(void) {
    test_printstr("Testing array operations...\n");
    
    // Test 1: Array sum
    int arr1[] = {1, 2, 3, 4, 5};
    int r1 = array_sum(arr1, 5);
    test_printstr("  sum([1..5]): ");
    test_printint(r1);
    TEST_ASSERT(r1 == 15);
    
    // Test 2: Max
    int arr2[] = {3, 1, 4, 1, 5, 9, 2, 6};
    int r2 = array_max(arr2, 8);
    test_printstr("\n  max: ");
    test_printint(r2);
    TEST_ASSERT(r2 == 9);
    
    // Test 3: Reverse
    int arr3[] = {1, 2, 3, 4, 5};
    array_reverse(arr3, 5);
    test_printstr("\n  reverse: ");
    test_printint(arr3[0]);
    test_printstr(", ");
    test_printint(arr3[4]);
    TEST_ASSERT(arr3[0] == 5 && arr3[4] == 1);
    
    // Test 4: Indexing
    int arr4[] = {10, 20, 30, 40, 50};
    int r4 = arr4[2];
    test_printstr("\n  arr[2]: ");
    test_printint(r4);
    TEST_ASSERT(r4 == 30);
    
    // Test 5: Pointer arithmetic
    int* p = arr4;
    int r5 = *(p + 3);
    test_printstr("\n  *(p+3): ");
    test_printint(r5);
    TEST_ASSERT(r5 == 40);
    
    test_printstr("\nAll array tests passed!\n");
    test_pass();
    return 0;
}