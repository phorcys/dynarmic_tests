// Array Index Test
// Tests: Simple array indexing
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing Array Indexing...\n");
    
    // Test 1: Simple array store/load
    int arr[10];
    arr[0] = 1;
    arr[1] = 2;
    arr[2] = 3;
    
    test_printstr("  arr[0]=");
    test_printint(arr[0]);
    test_printstr(" arr[1]=");
    test_printint(arr[1]);
    test_printstr(" arr[2]=");
    test_printint(arr[2]);
    TEST_ASSERT(arr[0] == 1);
    TEST_ASSERT(arr[1] == 2);
    TEST_ASSERT(arr[2] == 3);
    test_printstr(" OK\n");
    
    // Test 2: Loop-based array fill
    int arr2[5];
    for (int i = 0; i < 5; i++) {
        arr2[i] = i * 10;
    }
    
    test_printstr("  loop: ");
    for (int i = 0; i < 5; i++) {
        test_printint(arr2[i]);
        if (i < 4) test_printstr(",");
    }
    TEST_ASSERT(arr2[0] == 0);
    TEST_ASSERT(arr2[1] == 10);
    TEST_ASSERT(arr2[2] == 20);
    TEST_ASSERT(arr2[3] == 30);
    TEST_ASSERT(arr2[4] == 40);
    test_printstr(" OK\n");
    
    // Test 3: Conditional array store
    int arr3[4];
    int count = 0;
    arr3[count++] = 100;
    arr3[count++] = 200;
    arr3[count++] = 300;
    
    test_printstr("  cond: ");
    test_printint(arr3[0]);
    test_printstr(",");
    test_printint(arr3[1]);
    test_printstr(",");
    test_printint(arr3[2]);
    TEST_ASSERT(arr3[0] == 100);
    TEST_ASSERT(arr3[1] == 200);
    TEST_ASSERT(arr3[2] == 300);
    test_printstr(" OK\n");
    
    // Test 4: Compute then store
    int arr4[4];
    int idx = 0;
    int a = 5, b = 3;
    arr4[idx++] = a - b;  // Should be 2
    arr4[idx++] = a + b;  // Should be 8
    arr4[idx++] = a * b;  // Should be 15
    
    test_printstr("  calc: ");
    test_printint(arr4[0]);
    test_printstr(",");
    test_printint(arr4[1]);
    test_printstr(",");
    test_printint(arr4[2]);
    TEST_ASSERT(arr4[0] == 2);
    TEST_ASSERT(arr4[1] == 8);
    TEST_ASSERT(arr4[2] == 15);
    test_printstr(" OK\n");
    
    test_printstr("All array tests passed!\n");
    test_pass();
    return 0;
}
