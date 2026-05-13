/*
 * NEON Compare Test
 * Tests NEON comparison operations: CMEQ, CMGT, CMGE, CMHI, CMHS, CMLE, CMLT
 */

#include "test_syscall.h"

/* Vector types */
typedef struct { int8_t v[8]; } int8x8_t;
typedef struct { uint8_t v[8]; } uint8x8_t;

/* Compare equal (8-bit) */
static int test_cmeq(void) {
    test_printstr("Testing CMEQ...\n");
    
    uint8_t a[8] = { 10, 20, 30, 40, 50, 60, 70, 80 };
    uint8_t b[8] = { 10, 25, 30, 45, 50, 65, 70, 85 };
    
    int matches = 0;
    for (int i = 0; i < 8; i++) {
        if (a[i] == b[i]) matches++;
    }
    
    TEST_ASSERT(matches == 4);  /* 10, 30, 50, 70 */
    
    test_printstr("  CMEQ: PASS\n");
    return 0;
}

/* Compare greater than signed */
static int test_cmgt(void) {
    test_printstr("Testing CMGT...\n");
    
    int8_t a[8] = { 10, 20, -5, -10, 50, 60, -1, 80 };
    int8_t b[8] = { 5, 25, 5, -20, 40, 70, 0, 80 };
    
    int greater = 0;
    for (int i = 0; i < 8; i++) {
        if (a[i] > b[i]) greater++;
    }
    
    /* 10>5=true, 20>25=false, -5>5=false, -10>-20=true, 50>40=true, 60>70=false, -1>0=false, 80>80=false */
    TEST_ASSERT(greater == 3);
    
    test_printstr("  CMGT: PASS\n");
    return 0;
}

/* Compare greater than or equal */
static int test_cmge(void) {
    test_printstr("Testing CMGE...\n");
    
    int8_t a[8] = { 10, 20, 30, 40, 50, 60, 70, 80 };
    int8_t b[8] = { 10, 15, 35, 40, 45, 70, 75, 80 };
    
    int ge = 0;
    for (int i = 0; i < 8; i++) {
        if (a[i] >= b[i]) ge++;
    }
    
    TEST_ASSERT(ge == 5);  /* 10>=10, 20>=15, 40>=40, 50>=45, 80>=80 */
    
    test_printstr("  CMGE: PASS\n");
    return 0;
}

/* Compare higher (unsigned) */
static int test_cmhi(void) {
    test_printstr("Testing CMHI...\n");
    
    uint8_t a[8] = { 10, 200, 30, 40, 250, 60, 70, 80 };
    uint8_t b[8] = { 5, 100, 35, 40, 100, 65, 75, 80 };
    
    int higher = 0;
    for (int i = 0; i < 8; i++) {
        if (a[i] > b[i]) higher++;
    }
    
    /* 10>5=true, 200>100=true, 30>35=false, 40>40=false, 250>100=true, 60>65=false, 70>75=false, 80>80=false */
    TEST_ASSERT(higher == 3);
    
    test_printstr("  CMHI: PASS\n");
    return 0;
}

/* Compare less than or equal */
static int test_cmle(void) {
    test_printstr("Testing CMLE...\n");
    
    int8_t a[8] = { 10, 20, 30, 40, 50, 60, 70, 80 };
    int8_t b[8] = { 15, 20, 35, 30, 50, 70, 65, 90 };
    
    int le = 0;
    for (int i = 0; i < 8; i++) {
        if (a[i] <= b[i]) le++;
    }
    
    /* 10<=15=true, 20<=20=true, 30<=35=true, 40<=30=false, 50<=50=true, 60<=70=true, 70<=65=false, 80<=90=true */
    TEST_ASSERT(le == 6);
    
    test_printstr("  CMLE: PASS\n");
    return 0;
}

/* Compare less than */
static int test_cmlt(void) {
    test_printstr("Testing CMLT...\n");
    
    int8_t a[8] = { 10, 20, 30, 40, 50, 60, 70, 80 };
    int8_t b[8] = { 15, 20, 25, 50, 45, 60, 75, 70 };
    
    int lt = 0;
    for (int i = 0; i < 8; i++) {
        if (a[i] < b[i]) lt++;
    }
    
    TEST_ASSERT(lt == 3);  /* 10<15, 30<25 false, 40<50, 50<45 false */
    
    test_printstr("  CMLT: PASS\n");
    return 0;
}

/* Test compare against zero */
static int test_cmz(void) {
    test_printstr("Testing CMZ...\n");
    
    int8_t a[8] = { 0, -1, 1, 0, -5, 5, 0, 100 };
    
    int zeros = 0, negs = 0, pos = 0;
    for (int i = 0; i < 8; i++) {
        if (a[i] == 0) zeros++;
        else if (a[i] < 0) negs++;
        else pos++;
    }
    
    TEST_ASSERT(zeros == 3);
    TEST_ASSERT(negs == 2);
    TEST_ASSERT(pos == 3);
    
    test_printstr("  CMZ: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== NEON Compare Tests ===\n");
    
    test_cmeq();
    test_cmgt();
    test_cmge();
    test_cmhi();
    test_cmle();
    test_cmlt();
    test_cmz();
    
    test_printstr("All NEON compare tests passed!\n");
    test_pass();
    return 0;
}
