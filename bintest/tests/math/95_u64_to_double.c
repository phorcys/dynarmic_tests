// Test U64 to double conversion
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing U64 to double...\n");
    
    // Test 1: Small value
    unsigned long long u1 = 42ULL;
    double d1 = (double)u1;
    test_printstr("  small: ");
    test_printint((int)d1);
    test_printstr("\n");
    TEST_ASSERT(d1 == 42.0);
    
    // Test 2: Large value (just under 2^32)
    unsigned long long u2 = 0xFFFFFFFFULL;  // 4294967295
    double d2 = (double)u2;
    test_printstr("  u32_max: ");
    test_printint((int)(d2 / 1000000000.0));
    test_printstr("G\n");
    TEST_ASSERT(d2 > 4294000000.0 && d2 < 4300000000.0);
    
    // Test 3: Value >= 2^63 (if this works, U64 conversion is correct)
    unsigned long long u3 = 0x8000000000000000ULL;  // 2^63
    double d3 = (double)u3;
    test_printstr("  u63: ");
    // 2^63 as double is approximately 9.22e18
    // We can't easily print this, just check it's positive
    if (d3 > 0) {
        test_printstr("positive OK\n");
    } else {
        test_printstr("NEGATIVE ERROR!\n");
        TEST_ASSERT(0);
    }
    
    // Test 4: Maximum U64 value
    unsigned long long u4 = 0xFFFFFFFFFFFFFFFFULL;
    double d4 = (double)u4;
    test_printstr("  u64_max: ");
    if (d4 > 0) {
        test_printstr("positive OK\n");
    } else {
        test_printstr("NEGATIVE ERROR!\n");
        TEST_ASSERT(0);
    }
    
    test_printstr("All U64 to double tests passed!\n");
    test_pass();
    return 0;
}
