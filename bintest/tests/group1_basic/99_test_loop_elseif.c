#include "test_syscall.h"

int test_main(void) {
    test_printstr("Test else-if in loop...\n");
    
    const char* expr = "100-42";
    
    for (int i = 0; expr[i]; i++) {
        char c = expr[i];
        
        test_printstr("  i=");
        test_printint(i);
        test_printstr(" c='");
        test_putchar(c);
        test_printstr("': ");
        
        // Simple if-else if-else in loop
        if (c >= '0' && c <= '9') {
            test_printstr("[digit]");
        } else if (c == '-') {
            test_printstr("[minus]");
        } else {
            test_printstr("[other]");
        }
        test_printstr("\n");
    }
    
    test_pass();
    return 0;
}
