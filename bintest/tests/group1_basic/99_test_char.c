#include "test_syscall.h"

int test_main(void) {
    test_printstr("Test char comparison...\n");
    
    char c = '-';
    test_printstr("  c = '");
    test_putchar(c);
    test_printstr("'\n");
    
    test_printstr("  c == '-' ? ");
    if (c == '-') {
        test_printstr("YES\n");
    } else {
        test_printstr("NO\n");
    }
    
    test_printstr("  c == '+' ? ");
    if (c == '+') {
        test_printstr("YES\n");
    } else {
        test_printstr("NO\n");
    }
    
    test_printstr("  (int)c = ");
    test_printint((int)c);
    test_printstr("\n");
    
    test_printstr("  (int)'-' = ");
    test_printint((int)'-');
    test_printstr("\n");
    
    TEST_ASSERT(c == '-');
    test_pass();
    return 0;
}
