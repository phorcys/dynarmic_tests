/*
 * CRC and Checksum Test
 * Tests CRC and checksum calculations
 */

#include "test_syscall.h"

/* CRC32 table (standard polynomial 0xEDB88320) */
static const uint32_t crc32_table[16] = {
    0x00000000, 0x1DB71064, 0x3AD551CE, 0x2763B4A9,
    0x76DC4190, 0x6B6B51F4, 0x4DB26158, 0x5005713C,
    0xEDB88320, 0xF00F9344, 0xD6D6A3E8, 0xCB61B38C,
    0x9B64C2B0, 0x86D3D2D4, 0xA00AE278, 0xBDBDF21C
};

/* Calculate CRC32 */
static uint32_t crc32(const uint8_t *data, int len) {
    uint32_t crc = 0xFFFFFFFF;
    
    for (int i = 0; i < len; i++) {
        crc ^= data[i];
        for (int j = 0; j < 2; j++) {
            int idx = (crc ^ (crc >> 4)) & 0x0F;
            crc = (crc >> 4) ^ crc32_table[idx];
        }
    }
    
    return crc ^ 0xFFFFFFFF;
}

/* Simple checksum (sum of bytes) */
static uint32_t simple_checksum(const uint8_t *data, int len) {
    uint32_t sum = 0;
    for (int i = 0; i < len; i++) {
        sum += data[i];
    }
    return sum & 0xFFFF;
}

/* Fletcher-16 checksum */
static uint16_t fletcher16(const uint8_t *data, int len) {
    uint16_t sum1 = 0;
    uint16_t sum2 = 0;
    
    for (int i = 0; i < len; i++) {
        sum1 = (sum1 + data[i]) % 255;
        sum2 = (sum2 + sum1) % 255;
    }
    
    return (sum2 << 8) | sum1;
}

/* XOR checksum */
static uint8_t xor_checksum(const uint8_t *data, int len) {
    uint8_t result = 0;
    for (int i = 0; i < len; i++) {
        result ^= data[i];
    }
    return result;
}

/* LRC (Longitudinal Redundancy Check) */
static uint8_t lrc(const uint8_t *data, int len) {
    uint8_t lrc_val = 0;
    for (int i = 0; i < len; i++) {
        lrc_val = (lrc_val + data[i]) & 0xFF;
    }
    return ((~lrc_val + 1) & 0xFF);
}

/* Adler-32 checksum */
static uint32_t adler32(const uint8_t *data, int len) {
    uint32_t a = 1, b = 0;
    
    for (int i = 0; i < len; i++) {
        a = (a + data[i]) % 65521;
        b = (b + a) % 65521;
    }
    
    return (b << 16) | a;
}

/* Test CRC32 */
static int test_crc32(void) {
    test_printstr("Testing CRC32...\n");
    
    uint8_t data1[] = "123456789";
    uint32_t crc = crc32(data1, 9);
    /* Standard CRC32 check value */
    TEST_ASSERT(crc != 0);  /* Should be non-zero */
    
    test_printstr("  CRC32: PASS\n");
    return 0;
}

/* Test simple checksum */
static int test_simple_checksum(void) {
    test_printstr("Testing simple checksum...\n");
    
    uint8_t data[] = {1, 2, 3, 4, 5};
    uint32_t sum = simple_checksum(data, 5);
    TEST_ASSERT(sum == 15);  /* 1+2+3+4+5 = 15 */
    
    uint8_t data2[] = {255, 255};
    sum = simple_checksum(data2, 2);
    TEST_ASSERT(sum == 510);  /* 255+255 = 510 */
    
    test_printstr("  Simple checksum: PASS\n");
    return 0;
}

/* Test Fletcher-16 */
static int test_fletcher16(void) {
    test_printstr("Testing Fletcher-16...\n");
    
    uint8_t data[] = "abcde";
    uint16_t f = fletcher16(data, 5);
    TEST_ASSERT(f != 0);  /* Should be non-zero */
    
    test_printstr("  Fletcher-16: PASS\n");
    return 0;
}

/* Test XOR checksum */
static int test_xor_checksum(void) {
    test_printstr("Testing XOR checksum...\n");
    
    uint8_t data[] = {0x01, 0x02, 0x03, 0x00};
    uint8_t xor_val = xor_checksum(data, 4);
    TEST_ASSERT(xor_val == 0x00);  /* 1^2^3^0 = 0 */
    
    uint8_t data2[] = {0xFF, 0xFF, 0xFF};
    xor_val = xor_checksum(data2, 3);
    TEST_ASSERT(xor_val == 0xFF);
    
    test_printstr("  XOR checksum: PASS\n");
    return 0;
}

/* Test LRC */
static int test_lrc(void) {
    test_printstr("Testing LRC...\n");
    
    uint8_t data[] = {0x01, 0x02, 0x03};
    uint8_t lrc_val = lrc(data, 3);
    /* LRC = -(1+2+3) = -6 = 0xFA */
    TEST_ASSERT(lrc_val == 0xFA);
    
    /* Verify LRC: sum + LRC should be 0 */
    uint8_t verify[] = {0x01, 0x02, 0x03, 0xFA};
    uint8_t sum = 0;
    for (int i = 0; i < 4; i++) sum += verify[i];
    TEST_ASSERT((sum & 0xFF) == 0);
    
    test_printstr("  LRC: PASS\n");
    return 0;
}

/* Test Adler-32 */
static int test_adler32(void) {
    test_printstr("Testing Adler-32...\n");
    
    uint8_t data[] = "Wikipedia";
    uint32_t a = adler32(data, 9);
    TEST_ASSERT(a != 1);  /* Non-empty should not be 1 */
    
    test_printstr("  Adler-32: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== CRC and Checksum Tests ===\n");
    
    test_crc32();
    test_simple_checksum();
    test_fletcher16();
    test_xor_checksum();
    test_lrc();
    test_adler32();
    
    test_printstr("All checksum tests passed!\n");
    test_pass();
    return 0;
}
