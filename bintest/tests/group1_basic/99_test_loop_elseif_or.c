#include "test_syscall.h"

int test_main(void) {
    test_printstr("Test else-if with OR in loop...\n");
    
    const char* expr = "100-42";
    
    for (int i = 0; expr[i]; i++) {
        char c = expr[i];
        
        test_printstr("  i=");
        test_printint(i);
        test_printstr(" c='");
        test_putchar(c);
        test_printstr("': ");
        
        // if-else if with multiple OR conditions in loop
        if (c >= '0' && c <= '9') {
            test_printstr("[digit]");
        } else if (c == '+' || c == '-') {
            test_printstr("[plus/minus]");
        } else if (c == '*' || c == '/') {
            test_printstr("[mul/div]");
        } else {
            test_printstr("[other]");
        }
        test_printstr("\n");
    }
    
    test_pass();
    return 0;
}
