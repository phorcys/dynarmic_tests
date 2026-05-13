/* Test: Integer comparison operations */
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing integer comparisons...\n");
    
    long a = 100, b = 200, c = 100;
    
    // Equal
    TEST_ASSERT(a == c);
    test_printstr("  Equal: PASS\n");
    
    // Not equal
    TEST_ASSERT(a != b);
    test_printstr("  Not equal: PASS\n");
    
    // Less than
    TEST_ASSERT(a < b);
    test_printstr("  Less than: PASS\n");
    
    // Greater than
    TEST_ASSERT(b > a);
    test_printstr("  Greater than: PASS\n");
    
    // Less or equal
    TEST_ASSERT(a <= c);
    test_printstr("  Less or equal: PASS\n");
    
    // Greater or equal
    TEST_ASSERT(a >= c);
    test_printstr("  Greater or equal: PASS\n");
    
    // Signed comparison with negatives
    long neg = -1, pos = 1;
    TEST_ASSERT(neg < pos);
    test_printstr("  Signed comparison: PASS\n");
    
    // Unsigned comparison
    unsigned long u_neg = 0xFFFFFFFF;
    unsigned long u_pos = 1;
    TEST_ASSERT(u_neg > u_pos);  // As unsigned, 0xFFFFFFFF is largest
    test_printstr("  Unsigned comparison: PASS\n");
    
    test_printstr("All comparison tests passed!\n");
    test_pass();
    return 0;
}
