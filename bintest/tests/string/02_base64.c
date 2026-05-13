// Base64 Encoding/Decoding Test
// Tests: Base64 encode and decode operations
#include "test_syscall.h"

static const char b64_table[] = 
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static const int b64_decode_table[256] = {
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,62,-1,-1,-1,63,
    52,53,54,55,56,57,58,59,60,61,-1,-1,-1,-1,-1,-1,
    -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,
    15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1,
    -1,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,
    41,42,43,44,45,46,47,48,49,50,51,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
};

int base64_encode(const unsigned char *in, int len, char *out) {
    int j = 0;
    for (int i = 0; i < len; i += 3) {
        int n = ((unsigned int)in[i]) << 16;
        if (i + 1 < len) n |= ((unsigned int)in[i+1]) << 8;
        if (i + 2 < len) n |= in[i+2];
        
        out[j++] = b64_table[(n >> 18) & 0x3F];
        out[j++] = b64_table[(n >> 12) & 0x3F];
        out[j++] = (i + 1 < len) ? b64_table[(n >> 6) & 0x3F] : '=';
        out[j++] = (i + 2 < len) ? b64_table[n & 0x3F] : '=';
    }
    out[j] = '\0';
    return j;
}

int base64_decode(const char *in, int len, unsigned char *out) {
    int j = 0;
    for (int i = 0; i < len; i += 4) {
        int n = b64_decode_table[(unsigned char)in[i]] << 18;
        n |= b64_decode_table[(unsigned char)in[i+1]] << 12;
        n |= (in[i+2] == '=') ? 0 : b64_decode_table[(unsigned char)in[i+2]] << 6;
        n |= (in[i+3] == '=') ? 0 : b64_decode_table[(unsigned char)in[i+3]];
        
        out[j++] = (n >> 16) & 0xFF;
        if (in[i+2] != '=') out[j++] = (n >> 8) & 0xFF;
        if (in[i+3] != '=') out[j++] = n & 0xFF;
    }
    return j;
}

int mem_equals(const unsigned char *a, const unsigned char *b, int len) {
    for (int i = 0; i < len; i++) {
        if (a[i] != b[i]) return 0;
    }
    return 1;
}

int str_len(const char *s) {
    int len = 0;
    while (s[len]) len++;
    return len;
}

int test_main(void) {
    test_printstr("Testing Base64...\n");
    char encoded[256];
    unsigned char decoded[256];
    int len;
    
    // Test 1: "Hello"
    const unsigned char data1[] = "Hello";
    int len1 = 5;
    len = base64_encode(data1, len1, encoded);
    test_printstr("  enc_hello: ");
    test_printstr(encoded);
    TEST_ASSERT(encoded[0] == 'S' && encoded[1] == 'G');
    test_printstr(" OK\n");
    
    len = base64_decode(encoded, len, decoded);
    test_printstr("  dec_hello: ");
    TEST_ASSERT(len == 5);
    TEST_ASSERT(mem_equals(data1, decoded, len));
    test_printstr("OK\n");
    
    // Test 2: "World!"
    const unsigned char data2[] = "World!";
    int len2 = 6;
    base64_encode(data2, len2, encoded);
    test_printstr("  enc_world: ");
    test_printstr(encoded);
    test_printstr(" ");
    
    base64_decode(encoded, str_len(encoded), decoded);
    TEST_ASSERT(mem_equals(data2, decoded, len2));
    test_printstr("OK\n");
    
    // Test 3: Binary data
    const unsigned char data3[] = {0x00, 0x10, 0x83, 0x10, 0x51, 0x87, 0x20, 0x92, 0x8B};
    int len3 = 9;
    base64_encode(data3, len3, encoded);
    test_printstr("  binary: ");
    test_printstr(encoded);
    test_printstr(" ");
    
    base64_decode(encoded, str_len(encoded), decoded);
    TEST_ASSERT(mem_equals(data3, decoded, len3));
    test_printstr("OK\n");
    
    // Test 4: Single byte
    const unsigned char data4[] = "A";
    base64_encode(data4, 1, encoded);
    test_printstr("  single: ");
    test_printstr(encoded);
    TEST_ASSERT(encoded[2] == '=' && encoded[3] == '=');
    test_printstr(" ");
    
    base64_decode(encoded, 4, decoded);
    TEST_ASSERT(decoded[0] == 'A');
    test_printstr("OK\n");
    
    // Test 5: Two bytes
    const unsigned char data5[] = "AB";
    base64_encode(data5, 2, encoded);
    test_printstr("  double: ");
    test_printstr(encoded);
    TEST_ASSERT(encoded[3] == '=');
    test_printstr(" ");
    
    base64_decode(encoded, 4, decoded);
    TEST_ASSERT(mem_equals(data5, decoded, 2));
    test_printstr("OK\n");
    
    test_printstr("All Base64 tests passed!\n");
    test_pass();
    return 0;
}
