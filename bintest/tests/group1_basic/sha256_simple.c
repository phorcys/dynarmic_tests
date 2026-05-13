// Simplified SHA-256 Test
// Tests: Basic SHA-256 operations without full transform
#include "test_syscall.h"

static const unsigned int K[8] = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5
};

static const unsigned int H_INIT[8] = {
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
};

#define ROTR(x, n) (((x) >> (n)) | ((x) << (32 - (n))))

typedef struct {
    unsigned int state[8];
    unsigned char buffer[64];
    unsigned long long bitlen;
    unsigned int buflen;
} SHA256_CTX;

void sha256_init(SHA256_CTX *ctx) {
    for (int i = 0; i < 8; i++) ctx->state[i] = H_INIT[i];
    ctx->bitlen = 0;
    ctx->buflen = 0;
}

int test_main(void) {
    test_printstr("Testing SHA256 Simple...\n");
    
    // Test 1: Init
    SHA256_CTX ctx;
    sha256_init(&ctx);
    test_printstr("  init: ");
    TEST_ASSERT(ctx.state[0] == 0x6a09e667);
    TEST_ASSERT(ctx.state[7] == 0x5be0cd19);
    TEST_ASSERT(ctx.bitlen == 0);
    TEST_ASSERT(ctx.buflen == 0);
    test_printstr("OK\n");
    
    // Test 2: ROTR
    unsigned int a = 0x12345678;
    unsigned int r = ROTR(a, 7);
    test_printstr("  rotr: ");
    test_printhex(r);
    TEST_ASSERT(r == 0xf02468ac);
    test_printstr(" OK\n");
    
    // Test 3: K array access
    test_printstr("  k_arr: ");
    TEST_ASSERT(K[0] == 0x428a2f98);
    TEST_ASSERT(K[7] == 0xab1c5ed5);
    test_printstr("OK\n");
    
    // Test 4: State array modification
    ctx.state[0] = 0xDEADBEEF;
    ctx.state[3] = ctx.state[0] + K[0];
    test_printstr("  state: ");
    TEST_ASSERT(ctx.state[3] == 0xDEADBEEF + 0x428a2f98);
    test_printstr("OK\n");
    
    // Test 5: Buffer operations
    ctx.buffer[0] = 0x80;
    ctx.buffer[63] = 0x01;
    ctx.buflen = 64;
    test_printstr("  buf: ");
    TEST_ASSERT(ctx.buffer[0] == 0x80);
    TEST_ASSERT(ctx.buffer[63] == 0x01);
    TEST_ASSERT(ctx.buflen == 64);
    test_printstr("OK\n");
    
    // Test 6: 64-bit bitlen
    ctx.bitlen = 0x0102030405060708ULL;
    test_printstr("  bitlen: ");
    TEST_ASSERT(ctx.bitlen == 0x0102030405060708ULL);
    test_printstr("OK\n");
    
    test_printstr("All SHA256 simple tests passed!\n");
    test_pass();
    return 0;
}
