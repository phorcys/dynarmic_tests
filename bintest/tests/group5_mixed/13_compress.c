// Test simple compression-like operations
#include "test_syscall.h"

// RLE (Run-Length Encoding) compress
int rle_compress(unsigned char* input, int in_len, unsigned char* output) {
    int out_idx = 0;
    int i = 0;
    while (i < in_len) {
        unsigned char count = 1;
        while (i + count < in_len && count < 255 && input[i] == input[i + count]) {
            count++;
        }
        output[out_idx++] = count;
        output[out_idx++] = input[i];
        i += count;
    }
    return out_idx;
}

// RLE decompress
int rle_decompress(unsigned char* input, int in_len, unsigned char* output) {
    int out_idx = 0;
    for (int i = 0; i < in_len; i += 2) {
        unsigned char count = input[i];
        unsigned char val = input[i + 1];
        for (int j = 0; j < count; j++) {
            output[out_idx++] = val;
        }
    }
    return out_idx;
}

// Simple delta encoding
void delta_encode(unsigned char* input, int len, unsigned char* output) {
    output[0] = input[0];
    for (int i = 1; i < len; i++) {
        output[i] = input[i] - input[i - 1];
    }
}

void delta_decode(unsigned char* input, int len, unsigned char* output) {
    output[0] = input[0];
    for (int i = 1; i < len; i++) {
        output[i] = input[i] + output[i - 1];
    }
}

// Simple checksum
unsigned char checksum(unsigned char* data, int len) {
    unsigned char sum = 0;
    for (int i = 0; i < len; i++) {
        sum += data[i];
    }
    return sum;
}

int test_main(void) {
    test_printstr("Testing compression ops...\n");
    
    // Test 1: RLE compress
    unsigned char in1[] = {1, 1, 1, 2, 2, 3, 3, 3, 3, 4};
    unsigned char out1[20];
    int len1 = rle_compress(in1, 10, out1);
    test_printstr("  rle_comp: ");
    TEST_ASSERT(len1 == 8);  // (3,1),(2,2),(4,3),(1,4)
    TEST_ASSERT(out1[0] == 3 && out1[1] == 1);
    TEST_ASSERT(out1[2] == 2 && out1[3] == 2);
    test_printstr("OK\n");
    
    // Test 2: RLE decompress
    unsigned char decomp[20];
    int dlen = rle_decompress(out1, len1, decomp);
    test_printstr("  rle_decomp: ");
    TEST_ASSERT(dlen == 10);
    for (int i = 0; i < 10; i++) {
        TEST_ASSERT(decomp[i] == in1[i]);
    }
    test_printstr("OK\n");
    
    // Test 3: Delta encode
    unsigned char in3[] = {10, 12, 15, 14, 18};
    unsigned char delta[5];
    delta_encode(in3, 5, delta);
    test_printstr("  delta_enc: ");
    TEST_ASSERT(delta[0] == 10);  // first is same
    TEST_ASSERT(delta[1] == 2);   // 12-10
    TEST_ASSERT(delta[2] == 3);   // 15-12
    TEST_ASSERT((signed char)delta[3] == -1);  // 14-15 = -1
    TEST_ASSERT(delta[4] == 4);   // 18-14
    test_printstr("OK\n");
    
    // Test 4: Delta decode
    unsigned char decoded[5];
    delta_decode(delta, 5, decoded);
    test_printstr("  delta_dec: ");
    for (int i = 0; i < 5; i++) {
        TEST_ASSERT(decoded[i] == in3[i]);
    }
    test_printstr("OK\n");
    
    // Test 5: Checksum
    unsigned char data5[] = {1, 2, 3, 4, 5};
    unsigned char cs = checksum(data5, 5);
    test_printstr("  checksum: ");
    test_printint(cs);
    TEST_ASSERT(cs == 15);
    test_printstr(" OK\n");
    
    // Test 6: RLE with moderate run
    unsigned char in6[20];
    for (int i = 0; i < 10; i++) in6[i] = 7;
    for (int i = 10; i < 20; i++) in6[i] = 8;
    unsigned char out6[20];
    int len6 = rle_compress(in6, 20, out6);
    test_printstr("  rle_run: ");
    TEST_ASSERT(len6 == 4);  // (10,7), (10,8)
    test_printstr("OK\n");
    
    test_printstr("All compression tests passed!\n");
    test_pass();
    return 0;
}
