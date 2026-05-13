#include "test_syscall.h"

int test_main(void) {
    test_printstr("Test OR condition...\n");
    
    char c = '-';
    
    test_printstr("  c = '");
    test_putchar(c);
    test_printstr("'\n");
    
    // Test each comparison separately
    test_printstr("  c == '+' ? ");
    if (c == '+') test_printstr("YES"); else test_printstr("NO");
    test_printstr("\n");
    
    test_printstr("  c == '-' ? ");
    if (c == '-') test_printstr("YES"); else test_printstr("NO");
    test_printstr("\n");
    
    test_printstr("  c == '*' ? ");
    if (c == '*') test_printstr("YES"); else test_printstr("NO");
    test_printstr("\n");
    
    test_printstr("  c == '/' ? ");
    if (c == '/') test_printstr("YES"); else test_printstr("NO");
    test_printstr("\n");
    
    // Test OR condition
    test_printstr("  c == '+' || c == '-' ? ");
    if (c == '+' || c == '-') test_printstr("YES"); else test_printstr("NO");
    test_printstr("\n");
    
    test_printstr("  c == '+' || c == '-' || c == '*' || c == '/' ? ");
    if (c == '+' || c == '-' || c == '*' || c == '/') test_printstr("YES"); else test_printstr("NO");
    test_printstr("\n");
    
    TEST_ASSERT(c == '+' || c == '-' || c == '*' || c == '/');
    test_pass();
    return 0;
}
