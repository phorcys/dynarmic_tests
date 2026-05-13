#include "test_syscall.h"

int test_main(void) {
    test_printstr("Test simple else-if...\n");
    
    char c = '-';
    test_printstr("  c = '");
    test_putchar(c);
    test_printstr("'\n");
    
    // Simple if-else if-else
    if (c >= '0' && c <= '9') {
        test_printstr("  -> digit\n");
    } else if (c == '-') {
        test_printstr("  -> minus\n");
    } else {
        test_printstr("  -> other\n");
    }
    
    test_pass();
    return 0;
}
