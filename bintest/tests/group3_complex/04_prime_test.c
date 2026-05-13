// Test prime number algorithms
#include "test_syscall.h"

int is_prime(int n) {
    if (n < 2) return 0;
    if (n == 2) return 1;
    if (n % 2 == 0) return 0;
    for (int i = 3; i * i <= n; i += 2) {
        if (n % i == 0) return 0;
    }
    return 1;
}

int next_prime(int n) {
    if (n < 2) return 2;
    n++;
    while (!is_prime(n)) n++;
    return n;
}

int count_primes(int limit) {
    int count = 0;
    for (int i = 2; i < limit; i++) {
        if (is_prime(i)) count++;
    }
    return count;
}

int test_main(void) {
    test_printstr("Testing prime algorithms...\n");
    
    // Test 1: Small primes
    TEST_ASSERT(is_prime(2) == 1);
    TEST_ASSERT(is_prime(3) == 1);
    TEST_ASSERT(is_prime(5) == 1);
    TEST_ASSERT(is_prime(7) == 1);
    test_printstr("  small primes: OK\n");
    
    // Test 2: Non-primes
    TEST_ASSERT(is_prime(1) == 0);
    TEST_ASSERT(is_prime(4) == 0);
    TEST_ASSERT(is_prime(6) == 0);
    TEST_ASSERT(is_prime(9) == 0);
    test_printstr("  non-primes: OK\n");
    
    // Test 3: Larger primes
    TEST_ASSERT(is_prime(97) == 1);
    TEST_ASSERT(is_prime(101) == 1);
    TEST_ASSERT(is_prime(100) == 0);
    test_printstr("  larger primes: OK\n");
    
    // Test 4: Next prime
    int np = next_prime(10);
    test_printstr("  next_prime(10): ");
    test_printint(np);
    TEST_ASSERT(np == 11);
    
    np = next_prime(14);
    test_printstr("\n  next_prime(14): ");
    test_printint(np);
    TEST_ASSERT(np == 17);
    
    // Test 5: Count primes under 30
    int count = count_primes(30);
    test_printstr("\n  primes < 30: ");
    test_printint(count);
    // 2,3,5,7,11,13,17,19,23,29 = 10 primes
    TEST_ASSERT(count == 10);
    
    test_printstr("\nAll prime tests passed!\n");
    test_pass();
    return 0;
}
