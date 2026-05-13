// Test power and root algorithms
#include "test_syscall.h"

int power_int(int base, int exp) {
    int result = 1;
    while (exp > 0) {
        if (exp & 1) result *= base;
        base *= base;
        exp >>= 1;
    }
    return result;
}

long long power64(long long base, int exp) {
    long long result = 1;
    while (exp > 0) {
        if (exp & 1) result *= base;
        base *= base;
        exp >>= 1;
    }
    return result;
}

int isqrt(int n) {
    if (n < 0) return -1;
    if (n < 2) return n;
    
    int x = n;
    int y = (x + 1) / 2;
    while (y < x) {
        x = y;
        y = (x + n / x) / 2;
    }
    return x;
}

int icbrt(int n) {
    if (n < 0) return -icbrt(-n);
    if (n < 2) return n;
    
    int low = 1, high = n;
    while (low < high) {
        int mid = (low + high + 1) / 2;
        if (mid * mid * mid <= n) {
            low = mid;
        } else {
            high = mid - 1;
        }
    }
    return low;
}

int mod_power(int base, int exp, int mod) {
    int result = 1;
    base %= mod;
    while (exp > 0) {
        if (exp & 1) result = (result * base) % mod;
        base = (base * base) % mod;
        exp >>= 1;
    }
    return result;
}

int test_main(void) {
    test_printstr("Testing power and root...\n");
    
    // Test 1: Integer power
    int p = power_int(2, 10);
    test_printstr("  2^10 = ");
    test_printint(p);
    TEST_ASSERT(p == 1024);
    
    // Test 2: 64-bit power
    long long p64 = power64(3, 15);
    test_printstr("\n  3^15 = ");
    test_printint((int)(p64 % 1000000));  // Print last 6 digits
    // 3^15 = 14348907
    TEST_ASSERT(p64 == 14348907);
    
    // Test 3: Integer square root
    int sq = isqrt(16);
    test_printstr("\n  sqrt(16) = ");
    test_printint(sq);
    TEST_ASSERT(sq == 4);
    
    sq = isqrt(17);
    test_printstr("\n  sqrt(17) = ");
    test_printint(sq);
    TEST_ASSERT(sq == 4);  // Floor
    
    sq = isqrt(1000000);
    test_printstr("\n  sqrt(1000000) = ");
    test_printint(sq);
    TEST_ASSERT(sq == 1000);
    
    // Test 4: Integer cube root
    int cb = icbrt(27);
    test_printstr("\n  cbrt(27) = ");
    test_printint(cb);
    TEST_ASSERT(cb == 3);
    
    cb = icbrt(28);
    test_printstr("\n  cbrt(28) = ");
    test_printint(cb);
    TEST_ASSERT(cb == 3);  // Floor
    
    // Test 5: Modular power
    int mp = mod_power(2, 10, 100);
    test_printstr("\n  2^10 mod 100 = ");
    test_printint(mp);
    TEST_ASSERT(mp == 24);  // 1024 mod 100 = 24
    
    mp = mod_power(3, 100, 7);
    test_printstr("\n  3^100 mod 7 = ");
    test_printint(mp);
    TEST_ASSERT(mp == 4);  // Fermat's little theorem
    
    test_printstr("\nAll power/root tests passed!\n");
    test_pass();
    return 0;
}
