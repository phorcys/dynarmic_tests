// Test function pointers
#include "test_syscall.h"

typedef int (*binary_op)(int, int);

int add(int a, int b) { return a + b; }
int sub(int a, int b) { return a - b; }
int mul(int a, int b) { return a * b; }

binary_op ops[] = {add, sub, mul};

int test_main(void) {
    test_printstr("Testing function pointers...\n");
    
    binary_op op = add;
    int r1 = op(10, 20);
    test_printstr("  op=add, op(10,20): ");
    test_printint(r1);
    TEST_ASSERT(r1 == 30);
    
    op = mul;
    int r2 = op(5, 6);
    test_printstr("\n  op=mul, op(5,6): ");
    test_printint(r2);
    TEST_ASSERT(r2 == 30);
    
    int r3 = ops[0](10, 5);
    int r4 = ops[1](10, 5);
    int r5 = ops[2](10, 5);
    test_printstr("\n  ops array: ");
    test_printint(r3);
    test_printstr(", ");
    test_printint(r4);
    test_printstr(", ");
    test_printint(r5);
    TEST_ASSERT(r3 == 15 && r4 == 5 && r5 == 50);
    
    test_printstr("\nAll function pointer tests passed!\n");
    test_pass();
    return 0;
}