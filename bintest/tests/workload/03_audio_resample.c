// Audio Resampling Test (Linear Interpolation)
// Tests: Audio sample rate conversion
#include "test_syscall.h"

#define MAX_SAMPLES 100

// Linear interpolation between two values
int lerp(int a, int b, int t, int t_max) {
    return a + (b - a) * t / t_max;
}

// Upsample by factor (e.g., factor=2 doubles sample rate)
int upsample(int *input, int in_len, int *output, int factor) {
    int out_idx = 0;
    
    for (int i = 0; i < in_len - 1; i++) {
        output[out_idx++] = input[i];
        
        // Insert interpolated samples
        for (int f = 1; f < factor; f++) {
            output[out_idx++] = lerp(input[i], input[i + 1], f, factor);
        }
    }
    
    output[out_idx++] = input[in_len - 1];
    return out_idx;
}

// Downsample by factor (e.g., factor=2 halves sample rate)
int downsample(int *input, int in_len, int *output, int factor) {
    int out_idx = 0;
    
    for (int i = 0; i < in_len; i += factor) {
        output[out_idx++] = input[i];
    }
    
    return out_idx;
}

int test_main(void) {
    test_printstr("Testing Audio Resampling...\n");
    int input[MAX_SAMPLES];
    int output[MAX_SAMPLES * 4];
    int out_len;
    
    // Test 1: Simple upsampling
    int in1[] = {0, 100, 0};
    
    out_len = upsample(in1, 3, output, 2);
    test_printstr("  up2: ");
    test_printint(out_len);
    test_printstr(" samples: ");
    test_printint(output[0]);
    test_printstr(",");
    test_printint(output[1]);
    test_printstr(",");
    test_printint(output[2]);
    test_printstr(" ");
    TEST_ASSERT(out_len == 5);  // 3*2 - 1 = 5
    TEST_ASSERT(output[0] == 0);
    TEST_ASSERT(output[1] == 50);  // Interpolated: (0+100)/2
    TEST_ASSERT(output[2] == 100);
    test_printstr("OK\n");
    
    // Test 2: Downsampling
    int in2[] = {0, 25, 50, 75, 100, 125, 150, 175};
    
    out_len = downsample(in2, 8, output, 2);
    test_printstr("  down2: ");
    test_printint(out_len);
    test_printstr(" samples ");
    TEST_ASSERT(out_len == 4);
    TEST_ASSERT(output[0] == 0);
    TEST_ASSERT(output[1] == 50);
    TEST_ASSERT(output[2] == 100);
    TEST_ASSERT(output[3] == 150);
    test_printstr("OK\n");
    
    // Test 3: Upsample by 4
    int in3[] = {0, 100};
    
    out_len = upsample(in3, 2, output, 4);
    test_printstr("  up4: ");
    test_printint(out_len);
    test_printstr(" samples: ");
    test_printint(output[0]);
    test_printstr(",");
    test_printint(output[2]);
    test_printstr(",");
    test_printint(output[4]);
    test_printstr(" ");
    TEST_ASSERT(out_len == 5);  // 2*4 - 3 = 5
    TEST_ASSERT(output[0] == 0);
    TEST_ASSERT(output[2] == 50);  // 100/4*2
    test_printstr("OK\n");
    
    // Test 4: Round trip (up then down)
    int in4[] = {100, 200, 300};
    int temp[MAX_SAMPLES];
    
    int up_len = upsample(in4, 3, temp, 2);
    out_len = downsample(temp, up_len, output, 2);
    
    test_printstr("  roundtrip: ");
    TEST_ASSERT(output[0] == 100);
    TEST_ASSERT(output[1] == 200);
    TEST_ASSERT(output[2] == 300);
    test_printstr("OK\n");
    
    // Test 5: Constant signal
    int in5[] = {50, 50, 50, 50};
    
    out_len = upsample(in5, 4, output, 3);
    test_printstr("  const: ");
    int all_same = 1;
    for (int i = 0; i < out_len; i++) {
        if (output[i] != 50) all_same = 0;
    }
    TEST_ASSERT(all_same);
    test_printstr("OK\n");
    
    test_printstr("All Audio Resampling tests passed!\n");
    test_pass();
    return 0;
}
