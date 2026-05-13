/* Test: Integer assignment operations */
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing integer assignments...\n");
    
    // Simple assignment
    long a = 42;
    TEST_ASSERT(a == 42);
    test_printstr("  Simple: ");
    test_printint(a);
    test_newline();
    
    // Compound assignment (add)
    a += 10;
    TEST_ASSERT(a == 52);
    test_printstr("  +=: ");
    test_printint(a);
    test_newline();
    
    // Compound assignment (sub)
    a -= 2;
    TEST_ASSERT(a == 50);
    test_printstr("  -=: ");
    test_printint(a);
    test_newline();
    
    // Compound assignment (mul)
    a *= 2;
    TEST_ASSERT(a == 100);
    test_printstr("  *=: ");
    test_printint(a);
    test_newline();
    
    // Compound assignment (div)
    a /= 4;
    TEST_ASSERT(a == 25);
    test_printstr("  /=: ");
    test_printint(a);
    test_newline();
    
    // Compound assignment (and)
    a &= 0x1F;
    TEST_ASSERT(a == 25);
    test_printstr("  &=: ");
    test_printint(a);
    test_newline();
    
    // Compound assignment (or)
    a |= 0x40;
    TEST_ASSERT(a == 0x59);  // 25 | 64 = 89
    test_printstr("  |=: ");
    test_printint(a);
    test_newline();
    
    // Compound assignment (xor)
    a ^= 0xFF;
    test_printstr("  ^=: ");
    test_printint(a);
    test_newline();
    
    // Increment/decrement
    a++;
    test_printstr("  ++: ");
    test_printint(a);
    test_newline();
    
    a--;
    test_printstr("  --: ");
    test_printint(a);
    test_newline();
    
    test_printstr("All assignment tests passed!\n");
    test_pass();
    return 0;
}
