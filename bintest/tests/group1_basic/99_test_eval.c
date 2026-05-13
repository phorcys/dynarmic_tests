#include "test_syscall.h"

int evaluate_simple(const char* expr) {
    int result = 0;
    int num = 0;
    int op = '+';  // Start with addition
    
    test_printstr("  Debug: starting eval\n");
    
    for (int i = 0; expr[i]; i++) {
        char c = expr[i];
        test_printstr("    i=");
        test_printint(i);
        test_printstr(" c='");
        test_putchar(c);
        test_printstr("' num=");
        test_printint(num);
        test_printstr(" result=");
        test_printint(result);
        test_printstr(" op=");
        test_putchar(op);
        test_printstr("\n");
        
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
    
    test_printstr("  Debug: after loop, result=");
    test_printint(result);
    test_printstr(" num=");
    test_printint(num);
    test_printstr(" op=");
    test_putchar(op);
    test_printstr("\n");
    
    // Apply last operation
    if (op == '+') result += num;
    else if (op == '-') result -= num;
    else if (op == '*') result *= num;
    else if (op == '/') result /= num;
    
    test_printstr("  Debug: final result=");
    test_printint(result);
    test_printstr("\n");
    
    return result;
}

int test_main(void) {
    test_printstr("Test expression eval...\n");
    
    int r1 = evaluate_simple("100-42");
    test_printstr("  Result: 100-42 = ");
    test_printint(r1);
    test_printstr("\n");
    
    test_pass();
    return 0;
}
