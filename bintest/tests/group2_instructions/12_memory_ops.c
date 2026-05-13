// Test memory operations
#include "test_syscall.h"

static int global_array[16];

int test_main(void) {
    test_printstr("Testing memory operations...\n");
    
    // Test 1: Basic write/read
    int value = 0;
    int* ptr = &value;
    *ptr = 42;
    test_printstr("  write/read: ");
    test_printint(value);
    TEST_ASSERT(value == 42);
    
    // Test 2: Global array
    global_array[0] = 10;
    global_array[1] = 20;
    global_array[2] = 30;
    test_printstr("\n  global array: ");
    test_printint(global_array[0]);
    test_printstr(", ");
    test_printint(global_array[2]);
    TEST_ASSERT(global_array[0] == 10 && global_array[2] == 30);
    
    // Test 3: Local array
    int local_arr[4] = {1, 2, 3, 4};
    int sum = 0;
    for (int i = 0; i < 4; i++) {
        sum += local_arr[i];
    }
    test_printstr("\n  local array sum: ");
    test_printint(sum);
    TEST_ASSERT(sum == 10);
    
    // Test 4: Pointer arithmetic
    int arr[] = {0, 10, 20, 30, 40};
    int* p = arr + 2;
    test_printstr("\n  ptr + 2 = ");
    test_printint(*p);
    TEST_ASSERT(*p == 20);
    
    // Test 5: Pointer difference
    int diff = (arr + 4) - (arr + 1);
    test_printstr("\n  ptr diff: ");
    test_printint(diff);
    TEST_ASSERT(diff == 3);
    
    // Test 6: Multiple indirection
    int x = 100;
    int* px = &x;
    int** ppx = &px;
    test_printstr("\n  **ppx: ");
    test_printint(**ppx);
    TEST_ASSERT(**ppx == 100);
    
    test_printstr("\nAll memory tests passed!\n");
    test_pass();
    return 0;
}