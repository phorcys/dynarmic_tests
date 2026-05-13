// Sieve of Eratosthenes Test
// Tests: Prime number generation using Sieve of Eratosthenes
#include "test_syscall.h"

static int sieve[256];

void sieve_primes(int limit) {
    for (int i = 0; i <= limit && i < 256; i++) {
        sieve[i] = 1;
    }
    sieve[0] = 0;
    sieve[1] = 0;
    
    for (int i = 2; i * i <= limit; i++) {
        if (sieve[i]) {
            for (int j = i * i; j <= limit && j < 256; j += i) {
                sieve[j] = 0;
            }
        }
    }
}

int is_prime(int n) {
    if (n < 0 || n >= 256) return 0;
    return sieve[n];
}

int count_primes(int limit) {
    int count = 0;
    for (int i = 2; i <= limit; i++) {
        if (sieve[i]) count++;
    }
    return count;
}

int test_main(void) {
    test_printstr("Testing Sieve of Eratosthenes...\n");
    
    // Test 1: First few primes
    sieve_primes(100);
    
    test_printstr("  first: ");
    TEST_ASSERT(is_prime(2));
    TEST_ASSERT(is_prime(3));
    TEST_ASSERT(is_prime(5));
    TEST_ASSERT(is_prime(7));
    TEST_ASSERT(is_prime(11));
    test_printstr("OK\n");
    
    // Test 2: Non-primes
    test_printstr("  nonprime: ");
    TEST_ASSERT(!is_prime(0));
    TEST_ASSERT(!is_prime(1));
    TEST_ASSERT(!is_prime(4));
    TEST_ASSERT(!is_prime(6));
    TEST_ASSERT(!is_prime(9));
    test_printstr("OK\n");
    
    // Test 3: Count primes up to 100
    // There are 25 primes up to 100
    sieve_primes(100);
    int count = count_primes(100);
    
    test_printstr("  count100: ");
    test_printint(count);
    test_printstr(" ");
    TEST_ASSERT(count == 25);
    test_printstr("OK\n");
    
    // Test 4: Count primes up to 50
    // There are 15 primes up to 50
    sieve_primes(50);
    count = count_primes(50);
    
    test_printstr("  count50: ");
    test_printint(count);
    test_printstr(" ");
    TEST_ASSERT(count == 15);
    test_printstr("OK\n");
    
    // Test 5: Specific primes
    sieve_primes(200);
    
    test_printstr("  large: ");
    TEST_ASSERT(is_prime(97));
    TEST_ASSERT(is_prime(101));
    TEST_ASSERT(is_prime(127));
    TEST_ASSERT(!is_prime(100));
    TEST_ASSERT(!is_prime(121));  // 11^2
    test_printstr("OK\n");
    
    test_printstr("All Sieve tests passed!\n");
    test_pass();
    return 0;
}
