/* Test: Float arithmetic operations */
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing float arithmetic...\n");
    
    float a = 100.5f;
    float b = 25.25f;
    
    // Addition
    float sum = a + b;
    test_printstr("  Addition: ");
    test_printint((int)(sum * 100));  // 12575
    test_newline();
    TEST_ASSERT(sum > 125.7f && sum < 125.8f);
    
    // Subtraction
    float diff = a - b;
    test_printstr("  Subtraction: ");
    test_printint((int)(diff * 100));  // 7525
    test_newline();
    TEST_ASSERT(diff > 75.2f && diff < 75.3f);
    
    // Multiplication
    float prod = a * b;
    test_printstr("  Multiplication: ");
    test_printint((int)(prod));  // ~2538
    test_newline();
    
    // Division
    float quot = a / b;
    test_printstr("  Division: ");
    test_printint((int)(quot * 100));  // ~398
    test_newline();
    
    // Double precision
    double da = 1000000.5;
    double db = 2.5;
    double dprod = da * db;
    test_printstr("  Double mul: ");
    test_printint((int)(dprod));  // 2500001
    test_newline();
    
    // Negative float
    float neg = -42.5f;
    TEST_ASSERT(neg < 0);
    test_printstr("  Negative: ");
    test_printint((int)neg);  // -42
    test_newline();
    
    test_printstr("All float arithmetic tests passed!\n");
    test_pass();
    return 0;
}
