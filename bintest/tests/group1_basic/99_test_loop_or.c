#include "test_syscall.h"

int test_main(void) {
    test_printstr("Test loop OR condition...\n");
    
    const char* expr = "100-42";
    
    for (int i = 0; expr[i]; i++) {
        char c = expr[i];
        
        // Explicitly test each condition in loop
        int cond1 = (c == '+');
        int cond2 = (c == '-');
        int cond3 = (c == '*');
        int cond4 = (c == '/');
        int or_result = (c == '+' || c == '-' || c == '*' || c == '/');
        
        test_printstr("  i=");
        test_printint(i);
        test_printstr(" c='");
        test_putchar(c);
        test_printstr("' cond1=");
        test_printint(cond1);
        test_printstr(" cond2=");
        test_printint(cond2);
        test_printstr(" cond3=");
        test_printint(cond3);
        test_printstr(" cond4=");
        test_printint(cond4);
        test_printstr(" OR=");
        test_printint(or_result);
        test_printstr("\n");
    }
    
    test_pass();
    return 0;
}
