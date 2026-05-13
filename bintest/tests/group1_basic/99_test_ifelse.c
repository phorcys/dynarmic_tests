#include "test_syscall.h"

int test_main(void) {
    test_printstr("Test if-else if chain...\n");
    
    const char* expr = "100-42";
    
    for (int i = 0; expr[i]; i++) {
        char c = expr[i];
        
        test_printstr("  i=");
        test_printint(i);
        test_printstr(" c='");
        test_putchar(c);
        test_printstr("': ");
        
        if (c >= '0' && c <= '9') {
            test_printstr("[digit]");
        } else if (c == '+' || c == '-' || c == '*' || c == '/') {
            test_printstr("[operator]");
        } else {
            test_printstr("[unknown]");
        }
        test_printstr("\n");
    }
    
    test_pass();
    return 0;
}
