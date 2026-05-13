/* Test: Pointer basics */
#include "test_syscall.h"

// Global data for pointer tests
static long global_data = 100;
static long global_array[4] = {10, 20, 30, 40};

int test_main(void) {
    test_printstr("Testing pointer basics...\n");
    
    // Address-of operator
    long local = 42;
    long *ptr = &local;
    TEST_ASSERT(*ptr == 42);
    test_printstr("  Address-of: ");
    test_printint(*ptr);
    test_newline();
    
    // Pointer dereference
    *ptr = 100;
    TEST_ASSERT(local == 100);
    test_printstr("  Dereference: ");
    test_printint(local);
    test_newline();
    
    // Global pointer
    long *gptr = &global_data;
    TEST_ASSERT(*gptr == 100);
    *gptr = 200;
    TEST_ASSERT(global_data == 200);
    test_printstr("  Global pointer: ");
    test_printint(*gptr);
    test_newline();
    
    // Array access via pointer
    long *aptr = global_array;
    TEST_ASSERT(aptr[0] == 10);
    TEST_ASSERT(aptr[1] == 20);
    TEST_ASSERT(aptr[2] == 30);
    TEST_ASSERT(aptr[3] == 40);
    test_printstr("  Array via ptr: ");
    test_printint(aptr[2]);
    test_newline();
    
    // Pointer arithmetic
    aptr++;
    TEST_ASSERT(*aptr == 20);
    aptr += 2;
    TEST_ASSERT(*aptr == 40);
    test_printstr("  Pointer arithmetic: ");
    test_printint(*aptr);
    test_newline();
    
    // Pointer difference
    long *start = global_array;
    long *end = &global_array[3];
    long diff = end - start;
    TEST_ASSERT(diff == 3);
    test_printstr("  Pointer diff: ");
    test_printint(diff);
    test_newline();
    
    // Null pointer check
    long *null = (long*)0;
    TEST_ASSERT(null == (long*)0);
    test_printstr("  Null check: PASS\n");
    
    // Pointer to pointer
    long **pptr = &ptr;
    TEST_ASSERT(**pptr == 100);
    test_printstr("  Pointer to pointer: ");
    test_printint(**pptr);
    test_newline();
    
    test_printstr("All pointer tests passed!\n");
    test_pass();
    return 0;
}
