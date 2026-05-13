// Test Sieve of Eratosthenes
#include "test_syscall.h"

static int sieve[1000];

void sieve_primes(int limit) {
    for (int i = 0; i < limit; i++) {
        sieve[i] = 1;  // Assume all are prime
    }
    sieve[0] = sieve[1] = 0;  // 0 and 1 are not prime
    
    for (int i = 2; i * i < limit; i++) {
        if (sieve[i]) {
            for (int j = i * i; j < limit; j += i) {
                sieve[j] = 0;
            }
        }
    }
}

int count_sieve_primes(int limit) {
    int count = 0;
    for (int i = 2; i < limit; i++) {
        if (sieve[i]) count++;
    }
    return count;
}

int sum_sieve_primes(int limit) {
    int sum = 0;
    for (int i = 2; i < limit; i++) {
        if (sieve[i]) sum += i;
    }
    return sum;
}

int test_main(void) {
    test_printstr("Testing Sieve of Eratosthenes...\n");
    
    // Test 1: Sieve up to 100
    sieve_primes(100);
    int count = count_sieve_primes(100);
    test_printstr("  primes < 100: ");
    test_printint(count);
    TEST_ASSERT(count == 25);  // 25 primes under 100
    
    // Test 2: First few primes
    TEST_ASSERT(sieve[2] == 1);
    TEST_ASSERT(sieve[3] == 1);
    TEST_ASSERT(sieve[5] == 1);
    TEST_ASSERT(sieve[7] == 1);
    TEST_ASSERT(sieve[11] == 1);
    test_printstr("\n  first primes: OK\n");
    
    // Test 3: Composites marked correctly
    TEST_ASSERT(sieve[4] == 0);
    TEST_ASSERT(sieve[6] == 0);
    TEST_ASSERT(sieve[8] == 0);
    TEST_ASSERT(sieve[9] == 0);
    TEST_ASSERT(sieve[10] == 0);
    test_printstr("  composites: OK\n");
    
    // Test 4: Sum of primes under 100
    int sum = sum_sieve_primes(100);
    test_printstr("  sum of primes < 100: ");
    test_printint(sum);
    TEST_ASSERT(sum == 1060);
    
    // Test 5: Larger sieve
    sieve_primes(500);
    count = count_sieve_primes(500);
    test_printstr("\n  primes < 500: ");
    test_printint(count);
    TEST_ASSERT(count == 95);  // 95 primes under 500
    
    test_printstr("\nAll sieve tests passed!\n");
    test_pass();
    return 0;
}
