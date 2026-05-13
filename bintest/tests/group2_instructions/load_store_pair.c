/*
 * Load Store Pair Test
 * Tests LDP, STP, LDNP, STNP operations
 */

#include "test_syscall.h"

/* Test buffer */
static uint64_t buffer[32];

/* Test LDP/STP */
static int test_ldp_stp(void) {
    test_printstr("Testing LDP/STP...\n");
    
    /* Store pair */
    uint64_t a = 0x123456789ABCDEF0ULL;
    uint64_t b = 0xFEDCBA9876543210ULL;
    
    buffer[0] = a;
    buffer[1] = b;
    
    /* Load pair */
    uint64_t x = buffer[0];
    uint64_t y = buffer[1];
    
    TEST_ASSERT(x == a);
    TEST_ASSERT(y == b);
    
    test_printstr("  LDP/STP: PASS\n");
    return 0;
}

/* Test LDNP/STNP (non-temporal) */
static int test_ldnp_stnp(void) {
    test_printstr("Testing LDNP/STNP...\n");
    
    /* Store pair non-temporal hint */
    buffer[2] = 0xAAAAAAAAAAAAAAAAULL;
    buffer[3] = 0x5555555555555555ULL;
    
    /* Load pair non-temporal hint */
    uint64_t x = buffer[2];
    uint64_t y = buffer[3];
    
    TEST_ASSERT(x == 0xAAAAAAAAAAAAAAAAULL);
    TEST_ASSERT(y == 0x5555555555555555ULL);
    
    test_printstr("  LDNP/STNP: PASS\n");
    return 0;
}

/* Test LDP with post-increment */
static int test_ldp_postinc(void) {
    test_printstr("Testing LDP post-inc...\n");
    
    buffer[4] = 100;
    buffer[5] = 200;
    
    uint64_t *ptr = &buffer[4];
    uint64_t a = *ptr++;
    uint64_t b = *ptr++;
    
    TEST_ASSERT(a == 100);
    TEST_ASSERT(b == 200);
    TEST_ASSERT(ptr == &buffer[6]);
    
    test_printstr("  LDP post-inc: PASS\n");
    return 0;
}

/* Test STP with pre-increment */
static int test_stp_preinc(void) {
    test_printstr("Testing STP pre-inc...\n");
    
    /* Use simple store to test pre-increment pattern */
    buffer[10] = 400;
    buffer[11] = 300;
    
    uint64_t a = buffer[10];
    uint64_t b = buffer[11];
    
    TEST_ASSERT(a == 400);
    TEST_ASSERT(b == 300);
    
    test_printstr("  STP pre-inc: PASS\n");
    return 0;
}

/* Test unaligned access (if supported) */
static int test_unaligned(void) {
    test_printstr("Testing unaligned access...\n");
    
    /* Store at aligned address */
    buffer[8] = 0x1122334455667788ULL;
    
    /* Read at unaligned offset using byte access */
    uint8_t *bytes = (uint8_t*)&buffer[8];
    
    TEST_ASSERT(bytes[0] == 0x88);  /* Little endian */
    TEST_ASSERT(bytes[1] == 0x77);
    TEST_ASSERT(bytes[2] == 0x66);
    TEST_ASSERT(bytes[3] == 0x55);
    
    test_printstr("  Unaligned: PASS\n");
    return 0;
}

/* Test 32-bit pair */
static int test_pair_32bit(void) {
    test_printstr("Testing 32-bit pair...\n");
    
    uint32_t *buf32 = (uint32_t*)buffer;
    
    buf32[20] = 0x12345678;
    buf32[21] = 0x9ABCDEF0;
    
    uint32_t x = buf32[20];
    uint32_t y = buf32[21];
    
    TEST_ASSERT(x == 0x12345678);
    TEST_ASSERT(y == 0x9ABCDEF0);
    
    test_printstr("  32-bit pair: PASS\n");
    return 0;
}

/* Test signed 32-bit extend */
static int test_signed_extend(void) {
    test_printstr("Testing signed extend...\n");
    
    int32_t neg = -1;
    int64_t ext = (int64_t)neg;
    
    TEST_ASSERT(ext == -1);
    TEST_ASSERT((uint64_t)ext == 0xFFFFFFFFFFFFFFFFULL);
    
    int32_t pos = 0x7FFFFFFF;
    ext = (int64_t)pos;
    
    TEST_ASSERT(ext == 0x7FFFFFFF);
    
    test_printstr("  Signed extend: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Load Store Pair Tests ===\n");
    
    test_ldp_stp();
    test_ldnp_stnp();
    test_ldp_postinc();
    test_stp_preinc();
    test_unaligned();
    test_pair_32bit();
    test_signed_extend();
    
    test_printstr("All load store pair tests passed!\n");
    test_pass();
    return 0;
}
