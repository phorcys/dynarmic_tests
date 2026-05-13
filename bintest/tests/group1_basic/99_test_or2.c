#include "test_syscall.h"

int test_main(void) {
    test_printstr("Test OR condition detail...\n");
    
    const char* expr = "100-42";
    
    char c = expr[3];  // Should be '-'
    test_printstr("  c = '");
    test_putchar(c);
    test_printstr("' (int)c=");
    test_printint((int)c);
    test_printstr("\n");
    
    // Test each condition
    int cond1 = (c == '+');
    int cond2 = (c == '-');
    int cond3 = (c == '*');
    int cond4 = (c == '/');
    
    test_printstr("  c == '+': ");
    test_printint(cond1);
    test_printstr("\n");
    
    test_printstr("  c == '-': ");
    test_printint(cond2);
    test_printstr("\n");
    
    test_printstr("  c == '*': ");
    test_printint(cond3);
    test_printstr("\n");
    
    test_printstr("  c == '/': ");
    test_printint(cond4);
    test_printstr("\n");
    
    int or_result = (c == '+' || c == '-' || c == '*' || c == '/');
    test_printstr("  OR result: ");
    test_printint(or_result);
    test_printstr("\n");
    
    // Also test with explicit variable
    char minus = '-';
    test_printstr("  minus = '");
    test_putchar(minus);
    test_printstr("'\n");
    
    int or_result2 = (c == '+' || c == minus || c == '*' || c == '/');
    test_printstr("  OR with minus var: ");
    test_printint(or_result2);
    test_printstr("\n");
    
    TEST_ASSERT(c == '-');
    test_pass();
    return 0;
}
