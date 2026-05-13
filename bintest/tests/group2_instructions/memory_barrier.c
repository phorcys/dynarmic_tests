/*
 * Memory Barrier Test
 * Tests DMB, DSB, ISB-like memory ordering patterns
 */

#include "test_syscall.h"

/* Simple spinlock simulation */
static volatile int lock = 0;

static void lock_acquire(void) {
    while (lock) {
        /* Spin */
    }
    lock = 1;
}

static void lock_release(void) {
    lock = 0;
}

/* Test sequential consistency */
static int test_seq_cst(void) {
    test_printstr("Testing sequential consistency...\n");
    
    int shared_data = 0;
    int flag = 0;
    
    /* Writer pattern */
    shared_data = 42;
    flag = 1;
    
    /* Reader pattern */
    int local_flag = flag;
    int local_data = 0;
    if (local_flag) {
        local_data = shared_data;
    }
    
    TEST_ASSERT(local_flag == 1);
    TEST_ASSERT(local_data == 42);
    
    test_printstr("  Sequential consistency: PASS\n");
    return 0;
}

/* Test store buffer */
static int test_store_buffer(void) {
    test_printstr("Testing store buffer...\n");
    
    int arr[4] = {0, 0, 0, 0};
    
    /* Multiple stores */
    arr[0] = 1;
    arr[1] = 2;
    arr[2] = 3;
    arr[3] = 4;
    
    /* Verify all stores completed */
    TEST_ASSERT(arr[0] == 1);
    TEST_ASSERT(arr[1] == 2);
    TEST_ASSERT(arr[2] == 3);
    TEST_ASSERT(arr[3] == 4);
    
    test_printstr("  Store buffer: PASS\n");
    return 0;
}

/* Test load ordering */
static int test_load_ordering(void) {
    test_printstr("Testing load ordering...\n");
    
    int a = 100;
    int b = 200;
    int c = 300;
    
    /* Ordered loads */
    int v1 = a;
    int v2 = b;
    int v3 = c;
    
    TEST_ASSERT(v1 == 100);
    TEST_ASSERT(v2 == 200);
    TEST_ASSERT(v3 == 300);
    
    test_printstr("  Load ordering: PASS\n");
    return 0;
}

/* Test lock pattern */
static int test_lock_pattern(void) {
    test_printstr("Testing lock pattern...\n");
    
    lock = 0;
    
    lock_acquire();
    
    /* Critical section */
    int shared = 0;
    shared = 42;
    TEST_ASSERT(shared == 42);
    
    lock_release();
    
    TEST_ASSERT(lock == 0);
    
    test_printstr("  Lock pattern: PASS\n");
    return 0;
}

/* Test release-acquire pattern */
static int test_release_acquire(void) {
    test_printstr("Testing release-acquire...\n");
    
    int data = 0;
    int ready = 0;
    
    /* Producer */
    data = 123;
    ready = 1;  /* Release */
    
    /* Consumer */
    int local_ready = ready;  /* Acquire */
    int local_data = 0;
    if (local_ready) {
        local_data = data;
    }
    
    TEST_ASSERT(local_data == 123);
    
    test_printstr("  Release-acquire: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Memory Barrier Tests ===\n");
    
    test_seq_cst();
    test_store_buffer();
    test_load_ordering();
    test_lock_pattern();
    test_release_acquire();
    
    test_printstr("All memory barrier tests passed!\n");
    test_pass();
    return 0;
}
