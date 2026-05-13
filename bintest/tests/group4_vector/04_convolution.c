// Test convolution operation
#include "test_syscall.h"

int convolve(int* signal, int sig_len, int* kernel, int ker_len) {
    int sum = 0;
    for (int i = 0; i < ker_len && i < sig_len; i++) {
        sum += signal[i] * kernel[ker_len - 1 - i];
    }
    return sum;
}

void full_convolve(int* signal, int sig_len, int* kernel, int ker_len, int* result) {
    int out_len = sig_len + ker_len - 1;
    for (int i = 0; i < out_len; i++) {
        result[i] = 0;
        for (int j = 0; j < ker_len; j++) {
            int sig_idx = i - j;
            if (sig_idx >= 0 && sig_idx < sig_len) {
                result[i] += signal[sig_idx] * kernel[j];
            }
        }
    }
}

int test_main(void) {
    test_printstr("Testing convolution...\n");
    
    int signal[] = {1, 2, 3, 4, 5};
    int kernel[] = {1, 1, 1};
    int result[7];
    
    // Test 1: Single point convolution
    int c = convolve(signal, 5, kernel, 3);
    test_printstr("  conv point: ");
    test_printint(c);
    // 1*1 + 2*1 + 3*1 = 6
    TEST_ASSERT(c == 6);
    
    // Test 2: Full convolution
    full_convolve(signal, 5, kernel, 3, result);
    test_printstr("\n  full conv: ");
    test_printint(result[0]);
    test_printstr(" ");
    test_printint(result[4]);
    // result[0] = 1*1 = 1
    // result[4] = 3*1 + 4*1 + 5*1 = 12
    TEST_ASSERT(result[0] == 1 && result[4] == 12);
    
    test_printstr("\nAll convolution tests passed!\n");
    test_pass();
    return 0;
}
