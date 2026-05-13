// SHA-256 Debug Test
#include "test_syscall.h"

static const unsigned int K[64] = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
};

static const unsigned int H_INIT[8] = {
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
};

#define ROTR(x, n) (((x) >> (n)) | ((x) << (32 - (n))))
#define CH(x, y, z) (((x) & (y)) ^ (~(x) & (z)))
#define MAJ(x, y, z) (((x) & (y)) ^ ((x) & (z)) ^ ((y) & (z)))
#define EP0(x) (ROTR(x, 2) ^ ROTR(x, 13) ^ ROTR(x, 22))
#define EP1(x) (ROTR(x, 6) ^ ROTR(x, 11) ^ ROTR(x, 25))
#define SIG0(x) (ROTR(x, 7) ^ ROTR(x, 18) ^ ((x) >> 3))
#define SIG1(x) (ROTR(x, 17) ^ ROTR(x, 19) ^ ((x) >> 10))

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

void sha256_transform(SHA256_CTX *ctx, const unsigned char *data) {
    unsigned int W[64];
    unsigned int a, b, c, d, e, f, g, h, t1, t2;
    
    for (int i = 0; i < 16; i++) {
        W[i] = ((unsigned int)data[i*4] << 24) | ((unsigned int)data[i*4+1] << 16) |
               ((unsigned int)data[i*4+2] << 8) | ((unsigned int)data[i*4+3]);
    }
    for (int i = 16; i < 64; i++) {
        W[i] = SIG1(W[i-2]) + W[i-7] + SIG0(W[i-15]) + W[i-16];
    }
    
    a = ctx->state[0]; b = ctx->state[1]; c = ctx->state[2]; d = ctx->state[3];
    e = ctx->state[4]; f = ctx->state[5]; g = ctx->state[6]; h = ctx->state[7];
    
    for (int i = 0; i < 64; i++) {
        t1 = h + EP1(e) + CH(e, f, g) + K[i] + W[i];
        t2 = EP0(a) + MAJ(a, b, c);
        h = g; g = f; f = e; e = d + t1;
        d = c; c = b; b = a; a = t1 + t2;
    }
    
    ctx->state[0] += a; ctx->state[1] += b; ctx->state[2] += c; ctx->state[3] += d;
    ctx->state[4] += e; ctx->state[5] += f; ctx->state[6] += g; ctx->state[7] += h;
}

void sha256_update(SHA256_CTX *ctx, const unsigned char *data, unsigned int len) {
    for (unsigned int i = 0; i < len; i++) {
        ctx->buffer[ctx->buflen++] = data[i];
        if (ctx->buflen == 64) {
            sha256_transform(ctx, ctx->buffer);
            ctx->bitlen += 512;
            ctx->buflen = 0;
        }
    }
}

void sha256_final(SHA256_CTX *ctx, unsigned char *hash) {
    unsigned int i = ctx->buflen;
    
    ctx->bitlen += ctx->buflen * 8;
    ctx->buffer[i++] = 0x80;
    
    if (i > 56) {
        while (i < 64) ctx->buffer[i++] = 0;
        sha256_transform(ctx, ctx->buffer);
        i = 0;
    }
    
    while (i < 56) ctx->buffer[i++] = 0;
    
    ctx->buffer[56] = (ctx->bitlen >> 56) & 0xff;
    ctx->buffer[57] = (ctx->bitlen >> 48) & 0xff;
    ctx->buffer[58] = (ctx->bitlen >> 40) & 0xff;
    ctx->buffer[59] = (ctx->bitlen >> 32) & 0xff;
    ctx->buffer[60] = (ctx->bitlen >> 24) & 0xff;
    ctx->buffer[61] = (ctx->bitlen >> 16) & 0xff;
    ctx->buffer[62] = (ctx->bitlen >> 8) & 0xff;
    ctx->buffer[63] = ctx->bitlen & 0xff;
    
    sha256_transform(ctx, ctx->buffer);
    
    for (i = 0; i < 8; i++) {
        hash[i*4] = (ctx->state[i] >> 24) & 0xff;
        hash[i*4+1] = (ctx->state[i] >> 16) & 0xff;
        hash[i*4+2] = (ctx->state[i] >> 8) & 0xff;
        hash[i*4+3] = ctx->state[i] & 0xff;
    }
}

void print_hash(unsigned char *hash) {
    for (int i = 0; i < 32; i++) {
        unsigned char hi = (hash[i] >> 4) & 0xf;
        unsigned char lo = hash[i] & 0xf;
        test_putchar(hi < 10 ? '0'+hi : 'a'+hi-10);
        test_putchar(lo < 10 ? '0'+lo : 'a'+lo-10);
    }
}

int test_main(void) {
    test_printstr("Testing SHA-256...\n");
    SHA256_CTX ctx;
    unsigned char hash[32];
    
    // Test: "hello world"
    unsigned char data[] = "hello world";
    unsigned char expected[32] = {
        0xb9, 0x4d, 0x27, 0xb9, 0x93, 0x4d, 0x3e, 0x08,
        0xa5, 0x2e, 0x52, 0xd7, 0xda, 0x7d, 0xab, 0xfa,
        0xc4, 0x84, 0xef, 0xe3, 0x7a, 0x53, 0x80, 0xee,
        0x90, 0x88, 0xf7, 0xac, 0xe2, 0xef, 0xcd, 0xe9
    };
    
    sha256_init(&ctx);
    test_printstr("  After init: H[0]=");
    test_printhex(ctx.state[0]);
    test_printstr("\n");
    
    sha256_update(&ctx, data, 11);
    test_printstr("  After update: buflen=");
    test_putchar('0' + ctx.buflen);
    test_printstr(" bitlen=");
    test_printhex((unsigned int)(ctx.bitlen >> 32));
    test_printhex((unsigned int)(ctx.bitlen & 0xFFFFFFFF));
    test_printstr("\n");
    
    sha256_final(&ctx, hash);
    
    test_printstr("  Result: ");
    print_hash(hash);
    test_printstr("\n");
    
    test_printstr("  Expected: ");
    print_hash(expected);
    test_printstr("\n");
    
    test_printstr("  State: ");
    for (int i = 0; i < 8; i++) {
        test_printhex(ctx.state[i]);
        test_putchar(' ');
    }
    test_printstr("\n");
    
    // Compare
    int match = 1;
    for (int i = 0; i < 32; i++) {
        if (hash[i] != expected[i]) {
            match = 0;
            break;
        }
    }
    
    if (match) {
        test_printstr("  hello: OK\n");
    } else {
        test_printstr("  hello: FAIL\n");
        TEST_ASSERT(0);
    }
    
    test_pass();
    return 0;
}
