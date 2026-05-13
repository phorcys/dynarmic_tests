#include "test_syscall.h"

int test_main(void) {
    test_printstr("Test else-if with only operator check...\n");
    
    const char* expr = "100-42";
    
    for (int i = 0; expr[i]; i++) {
        char c = expr[i];
        
        test_printstr("  i=");
        test_printint(i);
        test_printstr(" c='");
        test_putchar(c);
        test_printstr("': ");
        
        // No digit check, just operator check
        if (c == '+' || c == '-' || c == '*' || c == '/') {
            test_printstr("[operator]");
        } else {
            test_printstr("[other]");
        }
        test_printstr("\n");
    }
    
    test_pass();
    return 0;
}
