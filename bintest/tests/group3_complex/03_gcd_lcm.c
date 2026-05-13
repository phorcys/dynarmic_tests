// Test GCD and LCM algorithms
#include "test_syscall.h"

int gcd(int a, int b) {
    while (b != 0) {
        int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

int lcm(int a, int b) {
    return (a / gcd(a, b)) * b;
}

int extended_gcd(int a, int b, int* x, int* y) {
    if (b == 0) {
        *x = 1;
        *y = 0;
        return a;
    }
    int x1, y1;
    int g = extended_gcd(b, a % b, &x1, &y1);
    *x = y1;
    *y = x1 - (a / b) * y1;
    return g;
}

int test_main(void) {
    test_printstr("Testing GCD and LCM...\n");
    
    // Test 1: Basic GCD
    int g = gcd(48, 18);
    test_printstr("  gcd(48, 18) = ");
    test_printint(g);
    TEST_ASSERT(g == 6);
    
    // Test 2: GCD with 1
    g = gcd(17, 1);
    test_printstr("\n  gcd(17, 1) = ");
    test_printint(g);
    TEST_ASSERT(g == 1);
    
    // Test 3: GCD of same numbers
    g = gcd(42, 42);
    test_printstr("\n  gcd(42, 42) = ");
    test_printint(g);
    TEST_ASSERT(g == 42);
    
    // Test 4: Basic LCM
    int l = lcm(12, 18);
    test_printstr("\n  lcm(12, 18) = ");
    test_printint(l);
    TEST_ASSERT(l == 36);
    
    // Test 5: LCM with 1
    l = lcm(17, 1);
    test_printstr("\n  lcm(17, 1) = ");
    test_printint(l);
    TEST_ASSERT(l == 17);
    
    // Test 6: Extended GCD
    int x, y;
    g = extended_gcd(35, 15, &x, &y);
    test_printstr("\n  ext_gcd(35, 15): g=");
    test_printint(g);
    test_printstr(", x=");
    test_printint(x);
    test_printstr(", y=");
    test_printint(y);
    // Verify: 35*x + 15*y = g
    TEST_ASSERT(35*x + 15*y == g);
    
    test_printstr("\nAll GCD/LCM tests passed!\n");
    test_pass();
    return 0;
}
