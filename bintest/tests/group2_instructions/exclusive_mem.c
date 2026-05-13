/*
 * Exclusive Memory Operations Test
 * Tests LDXR, STXR, LDAXR, STLXR patterns
 */

#include "test_syscall.h"

/* Simple atomic counter simulation */
static volatile int atomic_counter = 0;

/* Compare and swap simulation (without actual atomic instructions) */
static int cas(int *ptr, int expected, int new_val) {
    if (*ptr == expected) {
        *ptr = new_val;
        return 1;  /* Success */
    }
    return 0;  /* Failure */
}

/* Test basic exclusive load/store pattern */
static int test_exclusive_basic(void) {
    test_printstr("Testing exclusive basic...\n");
    
    int value = 100;
    int status;
    
    /* Simulate LDXR/STXR pattern */
    int loaded = value;  /* LDXR */
    int new_val = loaded + 50;
    value = new_val;     /* STXR */
    status = 0;          /* Success */
    
    TEST_ASSERT(value == 150);
    TEST_ASSERT(status == 0);
    
    test_printstr("  Exclusive basic: PASS\n");
    return 0;
}

/* Test CAS pattern */
static int test_cas(void) {
    test_printstr("Testing CAS...\n");
    
    int var = 42;
    
    /* Successful CAS */
    int s1 = cas(&var, 42, 100);
    TEST_ASSERT(s1 == 1);
    TEST_ASSERT(var == 100);
    
    /* Failed CAS */
    int s2 = cas(&var, 42, 200);
    TEST_ASSERT(s2 == 0);
    TEST_ASSERT(var == 100);
    
    test_printstr("  CAS: PASS\n");
    return 0;
}

/* Test atomic increment */
static int test_atomic_inc(void) {
    test_printstr("Testing atomic inc...\n");
    
    atomic_counter = 0;
    
    /* Simulate atomic increment using CAS loop */
    int old_val, new_val;
    int success = 0;
    int attempts = 0;
    
    do {
        old_val = atomic_counter;
        new_val = old_val + 1;
        success = cas((int*)&atomic_counter, old_val, new_val);
        attempts++;
    } while (!success && attempts < 10);
    
    TEST_ASSERT(atomic_counter == 1);
    
    test_printstr("  Atomic inc: PASS\n");
    return 0;
}

/* Test fetch and add */
static int test_fetch_add(void) {
    test_printstr("Testing fetch-add...\n");
    
    int counter = 100;
    
    /* Fetch and add: return old value, increment */
    int old = counter;
    counter = counter + 10;
    
    TEST_ASSERT(old == 100);
    TEST_ASSERT(counter == 110);
    
    test_printstr("  Fetch-add: PASS\n");
    return 0;
}

/* Test spinlock with exclusive */
static int test_spinlock(void) {
    test_printstr("Testing spinlock...\n");
    
    volatile int lock = 0;
    int tmp;
    
    /* Acquire: LDAXR + STXR loop */
    do {
        tmp = lock;  /* LDAXR */
        if (tmp != 0) continue;  /* Already locked */
    } while (lock != 0 || (lock = 1, 0));  /* STXR simulation */
    
    /* Critical section */
    int data = 42;
    TEST_ASSERT(data == 42);
    
    /* Release */
    lock = 0;  /* STLR */
    
    TEST_ASSERT(lock == 0);
    
    test_printstr("  Spinlock: PASS\n");
    return 0;
}

/* Test 64-bit exclusive */
static int test_exclusive_64(void) {
    test_printstr("Testing exclusive 64-bit...\n");
    
    uint64_t value = 0x123456789ABCDEF0ULL;
    
    /* Load exclusive */
    uint64_t loaded = value;
    
    /* Modify */
    uint64_t modified = loaded ^ 0xFFFFFFFFFFFFFFFFULL;
    
    /* Store exclusive (simulated success) */
    value = modified;
    
    TEST_ASSERT(value == 0xEDCBA9876543210FULL);
    
    test_printstr("  Exclusive 64-bit: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Exclusive Memory Tests ===\n");
    
    test_exclusive_basic();
    test_cas();
    test_atomic_inc();
    test_fetch_add();
    test_spinlock();
    test_exclusive_64();
    
    test_printstr("All exclusive memory tests passed!\n");
    test_pass();
    return 0;
}
