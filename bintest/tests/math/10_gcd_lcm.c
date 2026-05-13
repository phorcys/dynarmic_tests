// GCD and LCM Test
// Tests: Greatest Common Divisor and Least Common Multiple
#include "test_syscall.h"

int gcd(int a, int b) {
    while (b != 0) {
        int t = b;
        b = a % b;
        a = t;
    }
    return a < 0 ? -a : a;  // Make positive
}

int lcm(int a, int b) {
    if (a == 0 || b == 0) return 0;
    int g = gcd(a, b);
    a = a < 0 ? -a : a;
    b = b < 0 ? -b : b;
    return (a / g) * b;
}

int extended_gcd(int a, int b, int *x, int *y) {
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
    test_printstr("Testing GCD/LCM...\n");
    
    // Test 1: Basic GCD
    test_printstr("  gcd: ");
    TEST_ASSERT(gcd(48, 18) == 6);
    TEST_ASSERT(gcd(54, 24) == 6);
    TEST_ASSERT(gcd(17, 13) == 1);  // Primes
    TEST_ASSERT(gcd(12, 12) == 12);  // Same
    test_printstr("OK\n");
    
    // Test 2: GCD with zero
    test_printstr("  gcd_zero: ");
    TEST_ASSERT(gcd(0, 5) == 5);
    TEST_ASSERT(gcd(5, 0) == 5);
    test_printstr("OK\n");
    
    // Test 3: Basic LCM
    test_printstr("  lcm: ");
    TEST_ASSERT(lcm(4, 6) == 12);
    TEST_ASSERT(lcm(21, 6) == 42);
    TEST_ASSERT(lcm(8, 9) == 72);
    test_printstr("OK\n");
    
    // Test 4: LCM with relationship
    test_printstr("  lcm_rel: ");
    // LCM(a, b) * GCD(a, b) = a * b
    int a = 48, b = 18;
    int g = gcd(a, b);
    int l = lcm(a, b);
    TEST_ASSERT(g * l == a * b);
    test_printstr("OK\n");
    
    // Test 5: Extended GCD
    test_printstr("  extgcd: ");
    int x, y;
    g = extended_gcd(48, 18, &x, &y);
    TEST_ASSERT(g == 6);
    // 48*x + 18*y = 6
    TEST_ASSERT(48 * x + 18 * y == g);
    test_printstr("OK\n");
    
    // Test 6: Coprime numbers
    test_printstr("  coprime: ");
    TEST_ASSERT(gcd(7, 11) == 1);
    TEST_ASSERT(gcd(13, 17) == 1);
    TEST_ASSERT(lcm(7, 11) == 77);
    test_printstr("OK\n");
    
    test_printstr("All GCD/LCM tests passed!\n");
    test_pass();
    return 0;
}
