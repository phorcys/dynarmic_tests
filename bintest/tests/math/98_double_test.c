// Double precision test
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing double...\n");
    
    // Test 1: Large number multiplication
    double d1 = 4294967296.0;  // 2^32
    test_printstr("  d1: ");
    test_printhex(*(unsigned long long*)&d1);
    test_printstr("\n");
    
    // Test 2: Division by large number
    double d2 = 1.0 / 4294967296.0;
    test_printstr("  d2: ");
    test_printhex(*(unsigned long long*)&d2);
    test_printstr("\n");
    
    // Test 3: Integer to double conversion
    unsigned int u = 0xFFFFFFFF;
    double d3 = (double)u;
    test_printstr("  u2d: ");
    test_printint((int)(d3 / 1000000000.0));
    test_printstr("G\n");
    
    // Test 4: Double multiplication
    double d4 = (double)u * (1.0 / 4294967296.0);
    test_printstr("  mul: ");
    test_printint((int)(d4 * 1000));
    test_printstr("\n");
    // Should be close to 1000 (0xFFFFFFFF / 2^32 ≈ 1.0)
    TEST_ASSERT(d4 > 0.9 && d4 < 1.1);
    
    // Test 5: Array initialization
    int arr[10];
    for (int i = 0; i < 10; i++) arr[i] = 0;
    arr[5] = 100;
    test_printstr("  arr: ");
    test_printint(arr[5]);
    test_printstr("\n");
    TEST_ASSERT(arr[5] == 100);
    
    // Test 6: Double to int
    double d5 = 0.5;
    int i5 = (int)d5;
    test_printstr("  d2i: ");
    test_printint(i5);
    test_printstr("\n");
    TEST_ASSERT(i5 == 0);
    
    double d6 = 0.9;
    int i6 = (int)(d6 * 10.0);
    test_printstr("  d2i2: ");
    test_printint(i6);
    test_printstr("\n");
    TEST_ASSERT(i6 == 9);
    
    // Test 7: Uniform distribution simulation
    unsigned int vals[] = {100, 200, 300, 400, 500, 600, 700, 800, 900, 1000};
    int count[10] = {0};
    for (int i = 0; i < 10; i++) {
        double d = (double)vals[i] * (1.0 / 1000.0);  // 0.1 to 1.0
        int bin = (int)(d * 10.0);
        test_printstr("  bin[");
        test_printint(i);
        test_printstr("]: ");
        test_printint(bin);
        test_printstr("\n");
        if (bin >= 0 && bin < 10) count[bin]++;
    }
    test_printstr("  counts: ");
    for (int i = 0; i < 10; i++) {
        test_printint(count[i]);
        test_printstr(" ");
    }
    test_printstr("\n");
    
    test_printstr("All double tests passed!\n");
    test_pass();
    return 0;
}
