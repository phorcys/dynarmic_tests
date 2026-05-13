// MD5 Hash Test
// Tests: MD5 hash computation for various inputs
#include "test_syscall.h"

// MD5 shift amounts
static const unsigned int K[64] = {
    0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
    0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
    0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
    0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
    0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
    0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
    0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
    0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
    0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
    0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
    0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
    0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
    0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
    0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
};

static const unsigned int s[64] = {
    7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
    5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
    4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
    6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21
};

#define LEFTROTATE(x, c) (((x) << (c)) | ((x) >> (32 - (c))))

typedef struct {
    unsigned int h0, h1, h2, h3;
    unsigned char buffer[64];
    unsigned long long bitlen;
    unsigned int buflen;
} MD5_CTX;

void md5_init(MD5_CTX *ctx) {
    ctx->h0 = 0x67452301;
    ctx->h1 = 0xefcdab89;
    ctx->h2 = 0x98badcfe;
    ctx->h3 = 0x10325476;
    ctx->bitlen = 0;
    ctx->buflen = 0;
}

void md5_transform(MD5_CTX *ctx, const unsigned char *data) {
    unsigned int W[16];
    unsigned int a, b, c, d, f, g, temp;
    
    for (int i = 0; i < 16; i++) {
        W[i] = data[i*4] | (data[i*4+1] << 8) | (data[i*4+2] << 16) | (data[i*4+3] << 24);
    }
    
    a = ctx->h0; b = ctx->h1; c = ctx->h2; d = ctx->h3;
    
    for (int i = 0; i < 64; i++) {
        if (i < 16) {
            f = (b & c) | ((~b) & d);
            g = i;
        } else if (i < 32) {
            f = (d & b) | ((~d) & c);
            g = (5 * i + 1) % 16;
        } else if (i < 48) {
            f = b ^ c ^ d;
            g = (3 * i + 5) % 16;
        } else {
            f = c ^ (b | (~d));
            g = (7 * i) % 16;
        }
        
        temp = d;
        d = c;
        c = b;
        b = b + LEFTROTATE((a + f + K[i] + W[g]), s[i]);
        a = temp;
    }
    
    ctx->h0 += a; ctx->h1 += b; ctx->h2 += c; ctx->h3 += d;
}

void md5_update(MD5_CTX *ctx, const unsigned char *data, unsigned int len) {
    for (unsigned int i = 0; i < len; i++) {
        ctx->buffer[ctx->buflen++] = data[i];
        if (ctx->buflen == 64) {
            md5_transform(ctx, ctx->buffer);
            ctx->bitlen += 512;
            ctx->buflen = 0;
        }
    }
}

void md5_final(MD5_CTX *ctx, unsigned char *hash) {
    unsigned int i = ctx->buflen;
    
    ctx->bitlen += ctx->buflen * 8;
    ctx->buffer[i++] = 0x80;
    
    if (i > 56) {
        while (i < 64) ctx->buffer[i++] = 0;
        md5_transform(ctx, ctx->buffer);
        i = 0;
    }
    
    while (i < 56) ctx->buffer[i++] = 0;
    
    ctx->buffer[56] = ctx->bitlen & 0xff;
    ctx->buffer[57] = (ctx->bitlen >> 8) & 0xff;
    ctx->buffer[58] = (ctx->bitlen >> 16) & 0xff;
    ctx->buffer[59] = (ctx->bitlen >> 24) & 0xff;
    ctx->buffer[60] = 0; ctx->buffer[61] = 0; ctx->buffer[62] = 0; ctx->buffer[63] = 0;
    
    md5_transform(ctx, ctx->buffer);
    
    for (i = 0; i < 4; i++) {
        hash[i] = (ctx->h0 >> (i * 8)) & 0xff;
        hash[i + 4] = (ctx->h1 >> (i * 8)) & 0xff;
        hash[i + 8] = (ctx->h2 >> (i * 8)) & 0xff;
        hash[i + 12] = (ctx->h3 >> (i * 8)) & 0xff;
    }
}

int hash_equals(unsigned char *a, unsigned char *b, int len) {
    for (int i = 0; i < len; i++) {
        if (a[i] != b[i]) return 0;
    }
    return 1;
}

int test_main(void) {
    test_printstr("Testing MD5...\n");
    MD5_CTX ctx;
    unsigned char hash[16];
    
    // Test 1: Empty string
    // Expected: d41d8cd98f00b204e9800998ecf8427e
    unsigned char expected1[16] = {
        0xd4, 0x1d, 0x8c, 0xd9, 0x8f, 0x00, 0xb2, 0x04,
        0xe9, 0x80, 0x09, 0x98, 0xec, 0xf8, 0x42, 0x7e
    };
    md5_init(&ctx);
    md5_final(&ctx, hash);
    test_printstr("  empty: ");
    TEST_ASSERT(hash_equals(hash, expected1, 16));
    test_printstr("OK\n");
    
    // Test 2: "abc"
    // Expected: 900150983cd24fb0d6963f7d28e17f72
    unsigned char data2[] = "abc";
    unsigned char expected2[16] = {
        0x90, 0x01, 0x50, 0x98, 0x3c, 0xd2, 0x4f, 0xb0,
        0xd6, 0x96, 0x3f, 0x7d, 0x28, 0xe1, 0x7f, 0x72
    };
    md5_init(&ctx);
    md5_update(&ctx, data2, 3);
    md5_final(&ctx, hash);
    test_printstr("  abc: ");
    TEST_ASSERT(hash_equals(hash, expected2, 16));
    test_printstr("OK\n");
    
    // Test 3: "hello"
    unsigned char data3[] = "hello";
    unsigned char expected3[16] = {
        0x5d, 0x41, 0x40, 0x2a, 0xbc, 0x4b, 0x2a, 0x76,
        0xb9, 0x71, 0x9d, 0x91, 0x10, 0x17, 0xc5, 0x92
    };
    md5_init(&ctx);
    md5_update(&ctx, data3, 5);
    md5_final(&ctx, hash);
    test_printstr("  hello: ");
    TEST_ASSERT(hash_equals(hash, expected3, 16));
    test_printstr("OK\n");
    
    test_printstr("All MD5 tests passed!\n");
    test_pass();
    return 0;
}
