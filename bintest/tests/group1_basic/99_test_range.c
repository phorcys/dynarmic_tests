#include "test_syscall.h"

int test_main(void) {
    test_printstr("Test range condition...\n");
    
    const char* expr = "100-42";
    
    for (int i = 0; expr[i]; i++) {
        char c = expr[i];
        
        // Test the first condition
        int cond_a = (c >= '0');
        int cond_b = (c <= '9');
        int cond_and = (c >= '0' && c <= '9');
        
        // Test the second condition
        int cond_op = (c == '+' || c == '-' || c == '*' || c == '/');
        
        test_printstr("  i=");
        test_printint(i);
        test_printstr(" c='");
        test_putchar(c);
        test_printstr("' (int)c=");
        test_printint((int)c);
        test_printstr(" >=0=");
        test_printint(cond_a);
        test_printstr(" <=9=");
        test_printint(cond_b);
        test_printstr(" AND=");
        test_printint(cond_and);
        test_printstr(" OP=");
        test_printint(cond_op);
        test_printstr("\n");
    }
    
    test_pass();
    return 0;
}
