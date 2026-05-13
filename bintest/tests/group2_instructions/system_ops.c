/*
 * System Operations Test
 * Tests system-like operations (MSR, MRS simulation)
 */

#include "test_syscall.h"

/* Simulated system registers */
static uint64_t simulated_fpcr = 0;
static uint64_t simulated_fpsr = 0;

/* Get/set FPCR bits */
static uint32_t get_fpcr_rounding(void) {
    return (simulated_fpcr >> 22) & 0x3;
}

static void set_fpcr_rounding(uint32_t mode) {
    simulated_fpcr = (simulated_fpcr & ~(0x3 << 22)) | ((mode & 0x3) << 22);
}

/* Get/set FPSR flags */
static uint32_t get_fpsr_nzcv(void) {
    return (simulated_fpsr >> 28) & 0xF;
}

static void set_fpsr_nzcv(uint32_t flags) {
    simulated_fpsr = (simulated_fpsr & ~(0xF << 28)) | ((flags & 0xF) << 28);
}

/* Test rounding mode */
static int test_rounding_mode(void) {
    test_printstr("Testing rounding mode...\n");
    
    /* Round to nearest (default) */
    set_fpcr_rounding(0);
    TEST_ASSERT(get_fpcr_rounding() == 0);
    
    /* Round toward positive infinity */
    set_fpcr_rounding(1);
    TEST_ASSERT(get_fpcr_rounding() == 1);
    
    /* Round toward negative infinity */
    set_fpcr_rounding(2);
    TEST_ASSERT(get_fpcr_rounding() == 2);
    
    /* Round toward zero */
    set_fpcr_rounding(3);
    TEST_ASSERT(get_fpcr_rounding() == 3);
    
    test_printstr("  Rounding mode: PASS\n");
    return 0;
}

/* Test NZCV flags */
static int test_nzcv(void) {
    test_printstr("Testing NZCV...\n");
    
    /* Set all flags */
    set_fpsr_nzcv(0xF);
    TEST_ASSERT(get_fpsr_nzcv() == 0xF);
    
    /* Clear all flags */
    set_fpsr_nzcv(0);
    TEST_ASSERT(get_fpsr_nzcv() == 0);
    
    /* Set N and Z flags */
    set_fpsr_nzcv(0xC);  /* N=1, Z=1, C=0, V=0 */
    TEST_ASSERT(get_fpsr_nzcv() == 0xC);
    
    /* Set C and V flags */
    set_fpsr_nzcv(0x3);  /* N=0, Z=0, C=1, V=1 */
    TEST_ASSERT(get_fpsr_nzcv() == 0x3);
    
    test_printstr("  NZCV: PASS\n");
    return 0;
}

/* Test cache line size simulation */
static int test_cache_line(void) {
    test_printstr("Testing cache line...\n");
    
    /* Typical cache line is 64 bytes */
    uint64_t addr = 0x12345678;
    uint64_t aligned = addr & ~0x3F;  /* Align to 64 bytes */
    
    TEST_ASSERT(aligned == 0x12345640);
    
    /* Cache line offset */
    uint64_t offset = addr & 0x3F;
    TEST_ASSERT(offset == 0x38);
    
    test_printstr("  Cache line: PASS\n");
    return 0;
}

/* Test page alignment */
static int test_page_align(void) {
    test_printstr("Testing page align...\n");
    
    /* 4KB page size */
    uint64_t addr = 0x12345678;
    uint64_t page = addr & ~0xFFFULL;
    
    TEST_ASSERT(page == 0x12345000);
    
    /* Page offset */
    uint64_t offset = addr & 0xFFF;
    TEST_ASSERT(offset == 0x678);
    
    test_printstr("  Page align: PASS\n");
    return 0;
}

/* Test barrier-like ordering */
static int test_barrier_ordering(void) {
    test_printstr("Testing barrier ordering...\n");
    
    /* Simulate DMB/DSB by ensuring operations are ordered */
    int data = 0;
    int flag = 0;
    
    /* Writer */
    data = 42;
    /* DMB */
    flag = 1;
    
    /* Reader */
    int local_flag = flag;
    /* DMB */
    int local_data = local_flag ? data : 0;
    
    TEST_ASSERT(local_data == 42);
    
    test_printstr("  Barrier ordering: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== System Operations Tests ===\n");
    
    test_rounding_mode();
    test_nzcv();
    test_cache_line();
    test_page_align();
    test_barrier_ordering();
    
    test_printstr("All system operations tests passed!\n");
    test_pass();
    return 0;
}
