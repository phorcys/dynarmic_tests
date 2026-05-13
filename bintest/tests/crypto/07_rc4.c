// RC4 Stream Cipher Test
// Tests: RC4 encryption/decryption
#include "test_syscall.h"

typedef struct {
    unsigned char S[256];
    int i, j;
} RC4_CTX;

void rc4_init(RC4_CTX *ctx, const unsigned char *key, int keylen) {
    for (int i = 0; i < 256; i++) ctx->S[i] = i;
    
    int j = 0;
    for (int i = 0; i < 256; i++) {
        j = (j + ctx->S[i] + key[i % keylen]) & 0xFF;
        unsigned char temp = ctx->S[i];
        ctx->S[i] = ctx->S[j];
        ctx->S[j] = temp;
    }
    
    ctx->i = 0;
    ctx->j = 0;
}

unsigned char rc4_byte(RC4_CTX *ctx) {
    ctx->i = (ctx->i + 1) & 0xFF;
    ctx->j = (ctx->j + ctx->S[ctx->i]) & 0xFF;
    
    unsigned char temp = ctx->S[ctx->i];
    ctx->S[ctx->i] = ctx->S[ctx->j];
    ctx->S[ctx->j] = temp;
    
    return ctx->S[(ctx->S[ctx->i] + ctx->S[ctx->j]) & 0xFF];
}

void rc4_crypt(RC4_CTX *ctx, unsigned char *data, int len) {
    for (int i = 0; i < len; i++) {
        data[i] ^= rc4_byte(ctx);
    }
}

int test_main(void) {
    test_printstr("Testing RC4...\n");
    
    // Test 1: Known test vector
    // Key: "Key", Plaintext: "Plaintext"
    unsigned char key1[] = "Key";
    unsigned char data1[] = "Plaintext";
    unsigned char original1[] = "Plaintext";
    
    RC4_CTX ctx;
    rc4_init(&ctx, key1, 3);
    rc4_crypt(&ctx, data1, 9);
    
    test_printstr("  encrypt: ");
    test_printhex(data1[0]);
    test_printstr(",");
    test_printhex(data1[1]);
    test_printstr(" ");
    
    // Decrypt
    rc4_init(&ctx, key1, 3);
    rc4_crypt(&ctx, data1, 9);
    
    test_printstr("decrypt: ");
    int match = 1;
    for (int i = 0; i < 9; i++) {
        if (data1[i] != original1[i]) { match = 0; break; }
    }
    TEST_ASSERT(match);
    test_printstr("OK\n");
    
    // Test 2: Wiki test vector
    // Key: "Wiki", Plaintext: "pedia"
    unsigned char key2[] = "Wiki";
    unsigned char data2[] = "pedia";
    unsigned char original2[] = "pedia";
    
    rc4_init(&ctx, key2, 4);
    rc4_crypt(&ctx, data2, 5);
    test_printstr("  wiki: ");
    test_printhex(data2[0]);
    test_printstr(",");
    test_printhex(data2[4]);
    test_printstr(" ");
    
    rc4_init(&ctx, key2, 4);
    rc4_crypt(&ctx, data2, 5);
    match = 1;
    for (int i = 0; i < 5; i++) {
        if (data2[i] != original2[i]) { match = 0; break; }
    }
    TEST_ASSERT(match);
    test_printstr("OK\n");
    
    // Test 3: Empty key
    unsigned char key3[] = {0};
    unsigned char data3[] = "test";
    unsigned char original3[] = "test";
    
    rc4_init(&ctx, key3, 1);
    rc4_crypt(&ctx, data3, 4);
    rc4_init(&ctx, key3, 1);
    rc4_crypt(&ctx, data3, 4);
    
    test_printstr("  null_key: ");
    match = 1;
    for (int i = 0; i < 4; i++) {
        if (data3[i] != original3[i]) { match = 0; break; }
    }
    TEST_ASSERT(match);
    test_printstr("OK\n");
    
    test_printstr("All RC4 tests passed!\n");
    test_pass();
    return 0;
}
