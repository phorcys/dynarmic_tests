// XTEA Block Cipher Test
// Tests: XTEA encryption/decryption
#include "test_syscall.h"

#define DELTA 0x9E3779B9
#define NUM_ROUNDS 32

void xtea_encrypt(unsigned int *v, const unsigned int *key) {
    unsigned int v0 = v[0], v1 = v[1];
    unsigned int sum = 0;
    
    for (int i = 0; i < NUM_ROUNDS; i++) {
        v0 += (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + key[sum & 3]);
        sum += DELTA;
        v1 += (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + key[(sum >> 11) & 3]);
    }
    
    v[0] = v0; v[1] = v1;
}

void xtea_decrypt(unsigned int *v, const unsigned int *key) {
    unsigned int v0 = v[0], v1 = v[1];
    unsigned int sum = DELTA * NUM_ROUNDS;
    
    for (int i = 0; i < NUM_ROUNDS; i++) {
        v1 -= (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + key[(sum >> 11) & 3]);
        sum -= DELTA;
        v0 -= (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + key[sum & 3]);
    }
    
    v[0] = v0; v[1] = v1;
}

int test_main(void) {
    test_printstr("Testing XTEA...\n");
    
    unsigned int key[4] = {0x12345678, 0x9ABCDEF0, 0xFEDCBA98, 0x76543210};
    
    // Test 1: Encrypt/Decrypt roundtrip
    unsigned int block1[2] = {0x11223344, 0x55667788};
    unsigned int original1[2] = {block1[0], block1[1]};
    
    xtea_encrypt(block1, key);
    test_printstr("  encrypt: ");
    test_printhex(block1[0]);
    test_printstr(",");
    test_printhex(block1[1]);
    test_printstr(" ");
    
    xtea_decrypt(block1, key);
    test_printstr("decrypt: ");
    TEST_ASSERT(block1[0] == original1[0]);
    TEST_ASSERT(block1[1] == original1[1]);
    test_printstr("OK\n");
    
    // Test 2: Different key
    unsigned int key2[4] = {0, 0, 0, 0};
    unsigned int block2[2] = {0x00000001, 0x00000002};
    unsigned int original2[2] = {block2[0], block2[1]};
    
    xtea_encrypt(block2, key2);
    xtea_decrypt(block2, key2);
    test_printstr("  zero_key: ");
    TEST_ASSERT(block2[0] == original2[0]);
    TEST_ASSERT(block2[1] == original2[1]);
    test_printstr("OK\n");
    
    // Test 3: All ones
    unsigned int block3[2] = {0xFFFFFFFF, 0xFFFFFFFF};
    unsigned int original3[2] = {block3[0], block3[1]};
    
    xtea_encrypt(block3, key);
    xtea_decrypt(block3, key);
    test_printstr("  all_ones: ");
    TEST_ASSERT(block3[0] == original3[0]);
    TEST_ASSERT(block3[1] == original3[1]);
    test_printstr("OK\n");
    
    test_printstr("All XTEA tests passed!\n");
    test_pass();
    return 0;
}
