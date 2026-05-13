/* Test: Integer type casting */
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing integer casts...\n");
    
    // signed char to int
    signed char c = -50;
    int ci = (int)c;
    TEST_ASSERT(ci == -50);
    test_printstr("  char->int: ");
    test_printint(ci);
    test_newline();
    
    // unsigned char to int
    unsigned char uc = 200;
    int uci = (int)uc;
    TEST_ASSERT(uci == 200);
    test_printstr("  uchar->int: ");
    test_printint(uci);
    test_newline();
    
    // int to long
    int i = -12345;
    long li = (long)i;
    TEST_ASSERT(li == -12345);
    test_printstr("  int->long: ");
    test_printint(li);
    test_newline();
    
    // long to int (truncation)
    long l = 0x123456789ABCDEF0;
    int il = (int)l;
    TEST_ASSERT(il == 0x9ABCDEF0);
    test_printstr("  long->int: ");
    test_printhex(il);
    test_newline();
    
    // signed to unsigned
    int neg = -1;
    unsigned int uneg = (unsigned int)neg;
    test_printstr("  signed->unsigned: ");
    test_printhex(uneg);
    test_newline();
    
    // unsigned to signed
    unsigned int upos = 0x80000000;
    int spos = (int)upos;
    TEST_ASSERT(spos < 0);  // Should be negative
    test_printstr("  unsigned->signed: ");
    test_printint(spos);
    test_newline();
    
    // short promotion
    short s = -1000;
    int si = s;
    TEST_ASSERT(si == -1000);
    test_printstr("  short promotion: ");
    test_printint(si);
    test_newline();
    
    test_printstr("All cast tests passed!\n");
    test_pass();
    return 0;
}
