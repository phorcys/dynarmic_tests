/* Test: Float comparison operations */
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing float comparisons...\n");
    
    float a = 100.0f;
    float b = 200.0f;
    float c = 100.0f;
    
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
    
    // Negative comparison
    float neg = -1.0f;
    float pos = 1.0f;
    TEST_ASSERT(neg < pos);
    test_printstr("  Negative comparison: PASS\n");
    
    // Small difference
    float x = 1.000001f;
    float y = 1.000002f;
    TEST_ASSERT(x < y);
    test_printstr("  Small difference: PASS\n");
    
    // Double comparison
    double da = 1e10;
    double db = 1e10;
    TEST_ASSERT(da == db);
    test_printstr("  Double equal: PASS\n");
    
    test_printstr("All float comparison tests passed!\n");
    test_pass();
    return 0;
}
