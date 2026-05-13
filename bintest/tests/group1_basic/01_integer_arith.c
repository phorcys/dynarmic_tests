/* Test: Integer arithmetic operations */
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing integer arithmetic...\n");
    
    // Basic operations
    long a = 100, b = 25;
    
    // Addition
    long sum = a + b;
    TEST_ASSERT(sum == 125);
    test_printstr("  Addition: ");
    test_printint(sum);
    test_newline();
    
    // Subtraction
    long diff = a - b;
    TEST_ASSERT(diff == 75);
    test_printstr("  Subtraction: ");
    test_printint(diff);
    test_newline();
    
    // Multiplication
    long prod = a * b;
    TEST_ASSERT(prod == 2500);
    test_printstr("  Multiplication: ");
    test_printint(prod);
    test_newline();
    
    // Division
    long quot = a / b;
    TEST_ASSERT(quot == 4);
    test_printstr("  Division: ");
    test_printint(quot);
    test_newline();
    
    // Modulo
    long mod = a % b;
    TEST_ASSERT(mod == 0);
    test_printstr("  Modulo: ");
    test_printint(mod);
    test_newline();
    
    // Negative numbers
    long neg = -50;
    TEST_ASSERT(neg + 100 == 50);
    test_printstr("  Negative: ");
    test_printint(neg);
    test_newline();
    
    test_printstr("All arithmetic tests passed!\n");
    test_pass();
    return 0;
}
