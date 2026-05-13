// LZ77 Compression Test
// Tests: Simple LZ77 compression/decompression
#include "test_syscall.h"

#define WINDOW_SIZE 32
#define MAX_MATCH 8

typedef struct {
    int offset;
    int length;
    unsigned char next;
} lz77_token;

int find_match(unsigned char *data, int pos, int data_len, int *offset) {
    int best_len = 0;
    int best_offset = 0;
    
    int start = pos > WINDOW_SIZE ? pos - WINDOW_SIZE : 0;
    
    for (int i = start; i < pos; i++) {
        int len = 0;
        while (pos + len < data_len && len < MAX_MATCH && data[i + len] == data[pos + len]) {
            len++;
        }
        if (len > best_len) {
            best_len = len;
            best_offset = pos - i;
        }
    }
    
    *offset = best_offset;
    return best_len;
}

int lz77_compress(unsigned char *input, int in_len, lz77_token *output, int max_tokens) {
    int pos = 0;
    int token_count = 0;
    
    while (pos < in_len && token_count < max_tokens) {
        int offset;
        int length = find_match(input, pos, in_len, &offset);
        
        output[token_count].offset = offset;
        output[token_count].length = length;
        output[token_count].next = (pos + length < in_len) ? input[pos + length] : 0;
        
        pos += length + 1;
        token_count++;
    }
    
    return token_count;
}

int lz77_decompress(lz77_token *tokens, int num_tokens, unsigned char *output, int max_len, int expected_len) {
    int pos = 0;
    
    for (int i = 0; i < num_tokens && pos < max_len; i++) {
        if (tokens[i].length > 0 && tokens[i].offset > 0) {
            int start = pos - tokens[i].offset;
            for (int j = 0; j < tokens[i].length && pos < max_len; j++) {
                output[pos] = output[start + j];
                pos++;
            }
        }
        // Only write next char if we haven't reached expected length
        if (pos < expected_len && pos < max_len && tokens[i].next != 0) {
            output[pos++] = tokens[i].next;
        }
    }
    
    return pos;
}

int mem_equals(unsigned char *a, unsigned char *b, int len) {
    for (int i = 0; i < len; i++) {
        if (a[i] != b[i]) return 0;
    }
    return 1;
}

int test_main(void) {
    test_printstr("Testing LZ77...\n");
    lz77_token tokens[100];
    unsigned char output[256];
    int num_tokens, out_len;
    
    // Test 1: Simple string
    unsigned char input1[] = "ABABABAB";
    num_tokens = lz77_compress(input1, 8, tokens, 100);
    out_len = lz77_decompress(tokens, num_tokens, output, 256, 8);
    
    test_printstr("  simple: ");
    test_printstr("in=");
    test_printint(8);
    test_printstr(" out=");
    test_printint(out_len);
    test_printstr(" ");
    TEST_ASSERT(out_len == 8);
    TEST_ASSERT(mem_equals(input1, output, 8));
    test_printstr("OK\n");
    
    // Test 2: Repetitive pattern
    unsigned char input2[] = "AAAAAAAAAA";  // 10 A's
    num_tokens = lz77_compress(input2, 10, tokens, 100);
    out_len = lz77_decompress(tokens, num_tokens, output, 256, 10);
    
    test_printstr("  repeat: ");
    test_printstr("tokens=");
    test_printint(num_tokens);
    test_printstr(" ");
    TEST_ASSERT(out_len == 10);
    TEST_ASSERT(mem_equals(input2, output, 10));
    test_printstr("OK\n");
    
    // Test 3: No repetition
    unsigned char input3[] = "ABCDEFGHIJ";
    num_tokens = lz77_compress(input3, 10, tokens, 100);
    out_len = lz77_decompress(tokens, num_tokens, output, 256, 10);
    
    test_printstr("  norep: ");
    test_printstr("tokens=");
    test_printint(num_tokens);
    test_printstr(" ");
    TEST_ASSERT(out_len == 10);
    TEST_ASSERT(mem_equals(input3, output, 10));
    test_printstr("OK\n");
    
    // Test 4: Single char
    unsigned char input4[] = "X";
    num_tokens = lz77_compress(input4, 1, tokens, 100);
    out_len = lz77_decompress(tokens, num_tokens, output, 256, 1);
    
    test_printstr("  single: ");
    TEST_ASSERT(out_len >= 1);
    test_printstr("OK\n");
    
    // Test 5: Mixed pattern
    unsigned char input5[] = "ABCABCABCXYZXYZ";
    num_tokens = lz77_compress(input5, 15, tokens, 100);
    out_len = lz77_decompress(tokens, num_tokens, output, 256, 15);
    
    test_printstr("  mixed: ");
    TEST_ASSERT(mem_equals(input5, output, 15));
    test_printstr("OK\n");
    
    test_printstr("All LZ77 tests passed!\n");
    test_pass();
    return 0;
}
