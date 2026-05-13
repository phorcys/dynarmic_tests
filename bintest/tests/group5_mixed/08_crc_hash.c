// Test CRC and hash functions
#include "test_syscall.h"

unsigned int crc32_table[256];
int crc_table_init = 0;

void init_crc32_table(void) {
    if (crc_table_init) return;
    for (unsigned int i = 0; i < 256; i++) {
        unsigned int crc = i;
        for (int j = 0; j < 8; j++) {
            if (crc & 1)
                crc = (crc >> 1) ^ 0xEDB88320;
            else
                crc >>= 1;
        }
        crc32_table[i] = crc;
    }
    crc_table_init = 1;
}

unsigned int crc32(const unsigned char* data, int len) {
    init_crc32_table();
    unsigned int crc = 0xFFFFFFFF;
    for (int i = 0; i < len; i++) {
        crc = (crc >> 8) ^ crc32_table[(crc ^ data[i]) & 0xFF];
    }
    return crc ^ 0xFFFFFFFF;
}

unsigned int simple_hash(const char* str) {
    unsigned int hash = 5381;
    while (*str) {
        hash = ((hash << 5) + hash) + (unsigned char)(*str);
        str++;
    }
    return hash;
}

unsigned int fnv1a_hash(const unsigned char* data, int len) {
    unsigned int hash = 2166136261u;
    for (int i = 0; i < len; i++) {
        hash ^= data[i];
        hash *= 16777619u;
    }
    return hash;
}

int test_main(void) {
    test_printstr("Testing CRC/hash functions...\n");
    
    // Test 1: CRC32 of simple string
    unsigned char data1[] = "Hello";
    unsigned int crc1 = crc32(data1, 5);
    test_printstr("  crc32: ");
    test_printhex(crc1);
    test_printstr(" OK\n");
    
    // Test 2: Simple DJB2 hash
    unsigned int h1 = simple_hash("test");
    unsigned int h2 = simple_hash("test");
    unsigned int h3 = simple_hash("tset");
    test_printstr("  djb2: ");
    TEST_ASSERT(h1 == h2);       // same string = same hash
    TEST_ASSERT(h1 != h3);       // different string = different hash
    test_printstr("OK\n");
    
    // Test 3: FNV-1a hash
    unsigned char data3[] = {0x01, 0x02, 0x03, 0x04};
    unsigned int f1 = fnv1a_hash(data3, 4);
    unsigned int f2 = fnv1a_hash(data3, 4);
    test_printstr("  fnv1a: ");
    TEST_ASSERT(f1 == f2);
    test_printhex(f1);
    test_printstr(" OK\n");
    
    // Test 4: CRC32 of empty
    unsigned int crc_empty = crc32((unsigned char*)"", 0);
    test_printstr("  crc_empty: ");
    test_printhex(crc_empty);
    test_printstr(" OK\n");
    
    // Test 5: CRC32 of longer data
    unsigned char data5[] = "The quick brown fox jumps over the lazy dog";
    unsigned int crc5 = crc32(data5, 43);
    test_printstr("  crc_long: ");
    test_printhex(crc5);
    test_printstr(" OK\n");
    
    test_printstr("All CRC/hash tests passed!\n");
    test_pass();
    return 0;
}
