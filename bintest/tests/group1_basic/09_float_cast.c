/* Test: Float type casting */
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing float casts...\n");
    
    // int to float
    int i = 42;
    float fi = (float)i;
    test_printstr("  int->float: ");
    test_printint((int)fi);
    test_newline();
    TEST_ASSERT(fi == 42.0f);
    
    // float to int
    float f = 42.9f;
    int iff = (int)f;  // Truncates
    test_printstr("  float->int: ");
    test_printint(iff);
    test_newline();
    TEST_ASSERT(iff == 42);
    
    // double to float
    double d = 123.456;
    float fd = (float)d;
    test_printstr("  double->float: ");
    test_printint((int)(fd * 100));
    test_newline();
    
    // float to double
    float fs = 1.5f;
    double ds = (double)fs;
    test_printstr("  float->double: ");
    test_printint((int)(ds * 10));
    test_newline();
    
    // long to double
    long l = 1234567890L;
    double dl = (double)l;
    test_printstr("  long->double: ");
    test_printint((int)(dl / 1000000));
    test_newline();
    
    // double to long
    double dval = 12345678.9;
    long ld = (long)dval;
    test_printstr("  double->long: ");
    test_printint((int)(ld / 1000000));
    test_newline();
    
    // unsigned to float
    unsigned int u = 0xFFFFFFFF;
    float fu = (float)u;
    test_printstr("  unsigned->float: ");
    test_printint((int)(fu / 1e9));
    test_newline();
    
    test_printstr("All float cast tests passed!\n");
    test_pass();
    return 0;
}
