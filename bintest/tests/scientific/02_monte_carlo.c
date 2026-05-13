// Monte Carlo π Estimation Test
// Tests: Monte Carlo method for estimating π
#include "test_syscall.h"

// Simple PRNG for Monte Carlo
static unsigned int seed = 12345;

unsigned int simple_rand(void) {
    seed = seed * 1103515245 + 12345;
    return (seed >> 16) & 0x7fff;
}

double rand_double(void) {
    return (double)simple_rand() / 32768.0;
}

double estimate_pi(int samples) {
    int inside = 0;
    
    for (int i = 0; i < samples; i++) {
        double x = rand_double();
        double y = rand_double();
        
        // Check if point is inside unit circle
        double dist_sq = x * x + y * y;
        if (dist_sq <= 1.0) {
            inside++;
        }
    }
    
    // π ≈ 4 * (inside / total)
    return 4.0 * (double)inside / (double)samples;
}

int test_main(void) {
    test_printstr("Testing Monte Carlo π...\n");
    double pi_estimate;
    
    // Test 1: Small sample
    seed = 12345;
    pi_estimate = estimate_pi(100);
    test_printstr("  small: ");
    test_printint((int)(pi_estimate * 100));
    test_printstr(" ");
    // Should be roughly between 2.5 and 3.8
    TEST_ASSERT(pi_estimate > 2.0 && pi_estimate < 4.0);
    test_printstr("OK\n");
    
    // Test 2: Medium sample
    seed = 12345;
    pi_estimate = estimate_pi(1000);
    test_printstr("  medium: ");
    test_printint((int)(pi_estimate * 100));
    test_printstr(" ");
    // Should be closer to 3.14
    TEST_ASSERT(pi_estimate > 2.8 && pi_estimate < 3.5);
    test_printstr("OK\n");
    
    // Test 3: Reproducibility with same seed
    seed = 54321;
    double pi1 = estimate_pi(500);
    seed = 54321;
    double pi2 = estimate_pi(500);
    
    test_printstr("  repro: ");
    TEST_ASSERT(pi1 == pi2);
    test_printstr("OK\n");
    
    // Test 4: Different seeds give different results
    seed = 11111;
    double pi3 = estimate_pi(500);
    seed = 22222;
    double pi4 = estimate_pi(500);
    
    test_printstr("  diff: ");
    TEST_ASSERT(pi3 != pi4);
    test_printstr("OK\n");
    
    // Test 5: Larger sample (accuracy test)
    seed = 42;
    pi_estimate = estimate_pi(5000);
    test_printstr("  large: ");
    test_printint((int)(pi_estimate * 100));
    test_printstr(" ");
    // Should be closer to 314 (π ≈ 3.14)
    double error = pi_estimate - 3.14159;
    if (error < 0) error = -error;
    TEST_ASSERT(error < 0.3);  // Within 0.3
    test_printstr("OK\n");
    
    test_printstr("All Monte Carlo tests passed!\n");
    test_pass();
    return 0;
}
