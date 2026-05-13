// Test expression evaluation (simplified)
#include "test_syscall.h"

int evaluate_simple(const char* expr) {
    int result = 0;
    int num = 0;
    int op = '+';  // Start with addition
    
    for (int i = 0; expr[i]; i++) {
        char c = expr[i];
        if (c >= '0' && c <= '9') {
            num = num * 10 + (c - '0');
        } else if (c == '+' || c == '-' || c == '*' || c == '/') {
            // Apply previous operation
            if (op == '+') result += num;
            else if (op == '-') result -= num;
            else if (op == '*') result *= num;
            else if (op == '/') result /= num;
            
            num = 0;
            op = c;
        }
    }
    
    // Apply last operation
    if (op == '+') result += num;
    else if (op == '-') result -= num;
    else if (op == '*') result *= num;
    else if (op == '/') result /= num;
    
    return result;
}

int test_main(void) {
    test_printstr("Testing expression evaluation...\n");
    
    // Test 1: Simple addition
    int r = evaluate_simple("2+3");
    test_printstr("  2+3 = ");
    test_printint(r);
    TEST_ASSERT(r == 5);
    
    // Test 2: Multi-digit
    r = evaluate_simple("12+34");
    test_printstr("\n  12+34 = ");
    test_printint(r);
    TEST_ASSERT(r == 46);
    
    // Test 3: Subtraction
    r = evaluate_simple("100-42");
    test_printstr("\n  100-42 = ");
    test_printint(r);
    TEST_ASSERT(r == 58);
    
    // Test 4: Multiplication
    r = evaluate_simple("6*7");
    test_printstr("\n  6*7 = ");
    test_printint(r);
    TEST_ASSERT(r == 42);
    
    // Test 5: Division
    r = evaluate_simple("84/2");
    test_printstr("\n  84/2 = ");
    test_printint(r);
    TEST_ASSERT(r == 42);
    
    test_printstr("\nAll expression tests passed!\n");
    test_pass();
    return 0;
}
