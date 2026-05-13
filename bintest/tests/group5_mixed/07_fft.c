// Test simple FFT-like butterfly operations
#include "test_syscall.h"

// Simplified FFT butterfly (radix-2)
void fft_butterfly(int* real_in, int* imag_in, int* real_out, int* imag_out, int n) {
    // Simple 2-point DFT (butterfly)
    for (int i = 0; i < n; i += 2) {
        int a_r = real_in[i];
        int a_i = imag_in[i];
        int b_r = real_in[i + 1];
        int b_i = imag_in[i + 1];
        
        // Butterfly: out[k] = in[k] + in[k+n/2]
        //            out[k+n/2] = in[k] - in[k+n/2]
        real_out[i] = a_r + b_r;
        imag_out[i] = a_i + b_i;
        real_out[i + 1] = a_r - b_r;
        imag_out[i + 1] = a_i - b_i;
    }
}

// Bit reversal permutation
void bit_reverse(int* arr, int n) {
    int bits = 0;
    int temp = n;
    while (temp > 1) {
        bits++;
        temp >>= 1;
    }
    
    for (int i = 0; i < n; i++) {
        int rev = 0;
        for (int j = 0; j < bits; j++) {
            rev = (rev << 1) | ((i >> j) & 1);
        }
        if (rev > i) {
            int t = arr[i];
            arr[i] = arr[rev];
            arr[rev] = t;
        }
    }
}

int test_main(void) {
    test_printstr("Testing FFT operations...\n");
    
    // Test 1: Simple butterfly
    int real_in[] = {1, 2, 3, 4, 5, 6, 7, 8};
    int imag_in[] = {0, 0, 0, 0, 0, 0, 0, 0};
    int real_out[8], imag_out[8];
    fft_butterfly(real_in, imag_in, real_out, imag_out, 8);
    test_printstr("  butterfly: ");
    TEST_ASSERT(real_out[0] == 3);   // 1+2
    TEST_ASSERT(real_out[1] == -1);  // 1-2
    TEST_ASSERT(real_out[2] == 7);   // 3+4
    TEST_ASSERT(real_out[3] == -1);  // 3-4
    TEST_ASSERT(real_out[4] == 11);  // 5+6
    TEST_ASSERT(real_out[5] == -1);  // 5-6
    TEST_ASSERT(real_out[6] == 15);  // 7+8
    TEST_ASSERT(real_out[7] == -1);  // 7-8
    test_printstr("OK\n");
    
    // Test 2: Bit reversal
    int arr[] = {0, 1, 2, 3, 4, 5, 6, 7};
    bit_reverse(arr, 8);
    test_printstr("  bitrev: ");
    TEST_ASSERT(arr[0] == 0);  // 000 -> 000
    TEST_ASSERT(arr[1] == 4);  // 001 -> 100
    TEST_ASSERT(arr[2] == 2);  // 010 -> 010
    TEST_ASSERT(arr[3] == 6);  // 011 -> 110
    TEST_ASSERT(arr[4] == 1);  // 100 -> 001
    TEST_ASSERT(arr[5] == 5);  // 101 -> 101
    TEST_ASSERT(arr[6] == 3);  // 110 -> 011
    TEST_ASSERT(arr[7] == 7);  // 111 -> 111
    test_printstr("OK\n");
    
    // Test 3: 4-point DFT-like
    int r4[] = {1, 1, 1, 1};
    int i4[] = {0, 0, 0, 0};
    int ro4[4], io4[4];
    fft_butterfly(r4, i4, ro4, io4, 4);
    test_printstr("  dft4: ");
    TEST_ASSERT(ro4[0] == 2);   // 1+1
    TEST_ASSERT(ro4[1] == 0);   // 1-1
    TEST_ASSERT(ro4[2] == 2);   // 1+1
    TEST_ASSERT(ro4[3] == 0);   // 1-1
    test_printstr("OK\n");
    
    test_printstr("All FFT tests passed!\n");
    test_pass();
    return 0;
}
