// Gaussian Blur Test
// Tests: 2D convolution with Gaussian kernel
#include "test_syscall.h"

#define SIZE 8

// 3x3 Gaussian kernel (normalized)
// 1/16 * [1 2 1; 2 4 2; 1 2 1]
static const int kernel[3][3] = {
    {1, 2, 1},
    {2, 4, 2},
    {1, 2, 1}
};

void gaussian_blur(unsigned char input[SIZE][SIZE], unsigned char output[SIZE][SIZE]) {
    for (int y = 1; y < SIZE - 1; y++) {
        for (int x = 1; x < SIZE - 1; x++) {
            int sum = 0;
            for (int ky = -1; ky <= 1; ky++) {
                for (int kx = -1; kx <= 1; kx++) {
                    sum += input[y + ky][x + kx] * kernel[ky + 1][kx + 1];
                }
            }
            output[y][x] = (unsigned char)(sum / 16);
        }
    }
    
    // Copy borders (no blur)
    for (int i = 0; i < SIZE; i++) {
        output[0][i] = input[0][i];
        output[SIZE-1][i] = input[SIZE-1][i];
        output[i][0] = input[i][0];
        output[i][SIZE-1] = input[i][SIZE-1];
    }
}

int test_main(void) {
    test_printstr("Testing Gaussian Blur...\n");
    
    // Test 1: Uniform image (should stay uniform)
    unsigned char uniform[SIZE][SIZE];
    unsigned char result[SIZE][SIZE];
    
    for (int y = 0; y < SIZE; y++) {
        for (int x = 0; x < SIZE; x++) {
            uniform[y][x] = 128;
        }
    }
    
    gaussian_blur(uniform, result);
    
    test_printstr("  uniform: ");
    int uniform_ok = 1;
    for (int y = 1; y < SIZE - 1; y++) {
        for (int x = 1; x < SIZE - 1; x++) {
            if (result[y][x] != 128) uniform_ok = 0;
        }
    }
    TEST_ASSERT(uniform_ok);
    test_printstr("OK\n");
    
    // Test 2: Single bright pixel
    unsigned char single[SIZE][SIZE];
    for (int y = 0; y < SIZE; y++) {
        for (int x = 0; x < SIZE; x++) {
            single[y][x] = 0;
        }
    }
    single[4][4] = 255;  // Bright center
    
    gaussian_blur(single, result);
    
    test_printstr("  single: ");
    // Center should be brightest, neighbors should have some light
    TEST_ASSERT(result[4][4] > result[3][3]);  // Center brighter than corner
    TEST_ASSERT(result[4][4] > result[5][5]);
    test_printstr("OK\n");
    
    // Test 3: Checkerboard
    unsigned char checker[SIZE][SIZE];
    for (int y = 0; y < SIZE; y++) {
        for (int x = 0; x < SIZE; x++) {
            checker[y][x] = ((x + y) % 2) ? 255 : 0;
        }
    }
    
    gaussian_blur(checker, result);
    
    test_printstr("  checker: ");
    // All center pixels should converge to similar values
    int min_val = 255, max_val = 0;
    for (int y = 2; y < SIZE - 2; y++) {
        for (int x = 2; x < SIZE - 2; x++) {
            if (result[y][x] < min_val) min_val = result[y][x];
            if (result[y][x] > max_val) max_val = result[y][x];
        }
    }
    // After blur, checkerboard should have similar values everywhere
    TEST_ASSERT(max_val - min_val < 50);  // Reduced variance
    test_printstr("OK\n");
    
    // Test 4: Gradient
    unsigned char gradient[SIZE][SIZE];
    for (int y = 0; y < SIZE; y++) {
        for (int x = 0; x < SIZE; x++) {
            gradient[y][x] = x * 32;
        }
    }
    
    gaussian_blur(gradient, result);
    
    test_printstr("  gradient: ");
    // Gradient should be preserved (smoothed but still increasing)
    TEST_ASSERT(result[4][1] < result[4][6]);  // Left darker than right
    test_printstr("OK\n");
    
    test_printstr("All Gaussian blur tests passed!\n");
    test_pass();
    return 0;
}
