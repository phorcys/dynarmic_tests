// Test high complexity mixed operations - Algorithm combination
#include "test_syscall.h"

int is_prime(int n) {
    if (n < 2) return 0;
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) return 0;
    }
    return 1;
}

int sum_primes_in_array(int* arr, int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) {
        if (is_prime(arr[i])) {
            sum += arr[i];
        }
    }
    return sum;
}

void sort_array(int* arr, int n) {
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

int binary_search(int* arr, int n, int target) {
    int left = 0, right = n - 1;
    while (left <= right) {
        int mid = (left + right) / 2;
        if (arr[mid] == target) return mid;
        if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1;
}

int test_main(void) {
    test_printstr("Testing mixed operations...\n");
    
    int arr[] = {17, 3, 8, 11, 4, 19, 2, 7};
    int n = 8;
    
    // Test 1: Sum of primes
    int sum = sum_primes_in_array(arr, n);
    test_printstr("  sum primes: ");
    test_printint(sum);
    // 17+3+11+19+2+7 = 59
    TEST_ASSERT(sum == 59);
    
    // Test 2: Sort then search
    sort_array(arr, n);
    test_printstr("\n  sorted: ");
    test_printint(arr[0]);
    test_printstr("..");
    test_printint(arr[7]);
    TEST_ASSERT(arr[0] == 2 && arr[7] == 19);
    
    int idx = binary_search(arr, n, 11);
    test_printstr("\n  find 11: idx ");
    test_printint(idx);
    // Sorted array: [2, 3, 4, 7, 8, 11, 17, 19]
    // 11 is at index 5
    TEST_ASSERT(idx == 5);
    
    test_printstr("\nAll mixed tests passed!\n");
    test_pass();
    return 0;
}
