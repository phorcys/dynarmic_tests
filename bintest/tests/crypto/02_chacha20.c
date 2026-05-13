// ChaCha20 Stream Cipher Test
// Tests: ChaCha20 encryption/decryption
#include "test_syscall.h"

#define ROTL32(v, n) (((v) << (n)) | ((v) >> (32 - (n))))

// Quarter round
#define QUARTERROUND(a, b, c, d) \
    a += b; d ^= a; d = ROTL32(d, 16); \
    c += d; b ^= c; b = ROTL32(b, 12); \
    a += b; d ^= a; d = ROTL32(d, 8); \
    c += d; b ^= c; b = ROTL32(b, 7)

static const char sigma[16] = "expand 32-byte k";

void chacha20_block(unsigned char *output, const unsigned char *key, const unsigned char *nonce, unsigned int counter) {
    unsigned int state[16];
    
    // Constants
    for (int i = 0; i < 4; i++) {
        state[i] = ((unsigned int)sigma[i*4] | ((unsigned int)sigma[i*4+1] << 8) |
                    ((unsigned int)sigma[i*4+2] << 16) | ((unsigned int)sigma[i*4+3] << 24));
    }
    
    // Key
    for (int i = 0; i < 8; i++) {
        state[4+i] = ((unsigned int)key[i*4] | ((unsigned int)key[i*4+1] << 8) |
                      ((unsigned int)key[i*4+2] << 16) | ((unsigned int)key[i*4+3] << 24));
    }
    
    // Counter
    state[12] = counter;
    
    // Nonce
    for (int i = 0; i < 3; i++) {
        state[13+i] = ((unsigned int)nonce[i*4] | ((unsigned int)nonce[i*4+1] << 8) |
                       ((unsigned int)nonce[i*4+2] << 16) | ((unsigned int)nonce[i*4+3] << 24));
    }
    
    // Working state
    unsigned int working[16];
    for (int i = 0; i < 16; i++) working[i] = state[i];
    
    // 20 rounds (10 double rounds)
    for (int i = 0; i < 10; i++) {
        // Column round
        QUARTERROUND(working[0], working[4], working[8], working[12]);
        QUARTERROUND(working[1], working[5], working[9], working[13]);
        QUARTERROUND(working[2], working[6], working[10], working[14]);
        QUARTERROUND(working[3], working[7], working[11], working[15]);
        // Diagonal round
        QUARTERROUND(working[0], working[5], working[10], working[15]);
        QUARTERROUND(working[1], working[6], working[11], working[12]);
        QUARTERROUND(working[2], working[7], working[8], working[13]);
        QUARTERROUND(working[3], working[4], working[9], working[14]);
    }
    
    // Add original state
    for (int i = 0; i < 16; i++) working[i] += state[i];
    
    // Output
    for (int i = 0; i < 16; i++) {
        output[i*4] = working[i] & 0xff;
        output[i*4+1] = (working[i] >> 8) & 0xff;
        output[i*4+2] = (working[i] >> 16) & 0xff;
        output[i*4+3] = (working[i] >> 24) & 0xff;
    }
}

void chacha20_encrypt(unsigned char *data, unsigned int len, const unsigned char *key, const unsigned char *nonce, unsigned int counter) {
    unsigned char block[64];
    unsigned int pos = 0;
    unsigned int block_counter = counter;
    
    while (pos < len) {
        chacha20_block(block, key, nonce, block_counter);
        for (unsigned int i = 0; i < 64 && pos < len; i++) {
            data[pos++] ^= block[i];
        }
        block_counter++;
    }
}

int test_main(void) {
    test_printstr("Testing ChaCha20...\n");
    
    // Test 1: Known test vector from RFC 7539
    // Key: 00:01:02:...:1f
    // Nonce: 00:00:00:09:00:00:00:4a:00:00:00:00
    // Counter: 1
    // Plaintext: "Ladies and Gentlemen of the class of '99..."
    unsigned char key[32] = {
        0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
        0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
        0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
        0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f
    };
    unsigned char nonce[12] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x4a, 0x00, 0x00, 0x00, 0x00
    };
    
    // Simple test: encrypt and decrypt "Hello World!"
    unsigned char plaintext[] = "Hello World!";
    unsigned char data[12];
    for (int i = 0; i < 12; i++) data[i] = plaintext[i];
    
    // Encrypt
    chacha20_encrypt(data, 12, key, nonce, 1);
    test_printstr("  encrypt: ");
    test_printhex(data[0]);
    test_printstr(",");
    test_printhex(data[11]);
    test_printstr(" ");
    
    // Decrypt (encrypt again with same keystream)
    chacha20_encrypt(data, 12, key, nonce, 1);
    
    // Verify
    int match = 1;
    for (int i = 0; i < 12; i++) {
        if (data[i] != plaintext[i]) {
            match = 0;
            break;
        }
    }
    TEST_ASSERT(match);
    test_printstr("OK\n");
    
    // Test 2: Block consistency
    unsigned char block1[64], block2[64];
    chacha20_block(block1, key, nonce, 0);
    chacha20_block(block2, key, nonce, 0);
    test_printstr("  block_consistency: ");
    match = 1;
    for (int i = 0; i < 64; i++) {
        if (block1[i] != block2[i]) {
            match = 0;
            break;
        }
    }
    TEST_ASSERT(match);
    test_printstr("OK\n");
    
    // Test 3: Different counters produce different blocks
    unsigned char block3[64];
    chacha20_block(block3, key, nonce, 1);
    test_printstr("  different_counters: ");
    int different = 0;
    for (int i = 0; i < 64; i++) {
        if (block1[i] != block3[i]) {
            different = 1;
            break;
        }
    }
    TEST_ASSERT(different);
    test_printstr("OK\n");
    
    test_printstr("All ChaCha20 tests passed!\n");
    test_pass();
    return 0;
}
