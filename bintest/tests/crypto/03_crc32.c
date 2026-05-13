// CRC32 Checksum Test
// Tests: CRC32 computation for various inputs
#include "test_syscall.h"

// CRC32 lookup table (IEEE 802.3 polynomial)
static unsigned int crc32_table[256];

static int table_initialized = 0;

void init_crc32_table(void) {
    if (table_initialized) return;
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
    table_initialized = 1;
}

unsigned int crc32(const unsigned char *data, int len) {
    init_crc32_table();
    unsigned int crc = 0xFFFFFFFF;
    for (int i = 0; i < len; i++) {
        crc = (crc >> 8) ^ crc32_table[(crc ^ data[i]) & 0xFF];
    }
    return crc ^ 0xFFFFFFFF;
}

int test_main(void) {
    test_printstr("Testing CRC32...\n");
    
    // Test 1: Empty string
    unsigned int crc1 = crc32((unsigned char*)"", 0);
    test_printstr("  empty: ");
    test_printhex(crc1);
    TEST_ASSERT(crc1 == 0x00000000);
    test_printstr(" OK\n");
    
    // Test 2: "123456789" (standard check value)
    // Expected: 0xCBF43926
    unsigned char test2[] = "123456789";
    unsigned int crc2 = crc32(test2, 9);
    test_printstr("  check: ");
    test_printhex(crc2);
    TEST_ASSERT(crc2 == 0xCBF43926);
    test_printstr(" OK\n");
    
    // Test 3: "hello"
    unsigned char test3[] = "hello";
    unsigned int crc3 = crc32(test3, 5);
    test_printstr("  hello: ");
    test_printhex(crc3);
    // Expected: 0x3610A686
    TEST_ASSERT(crc3 == 0x3610A686);
    test_printstr(" OK\n");
    
    // Test 4: "Hello World!"
    unsigned char test4[] = "Hello World!";
    unsigned int crc4 = crc32(test4, 12);
    test_printstr("  helloworld: ");
    test_printhex(crc4);
    TEST_ASSERT(crc4 == 0x1C291CA3);
    test_printstr(" OK\n");
    
    // Test 5: Binary data
    unsigned char test5[] = {0x00, 0x01, 0x02, 0x03, 0xFF, 0xFE, 0xFD, 0xFC};
    unsigned int crc5 = crc32(test5, 8);
    test_printstr("  binary: ");
    test_printhex(crc5);
    test_printstr(" OK\n");
    
    // Test 6: Longer string
    unsigned char test6[] = "The quick brown fox jumps over the lazy dog";
    unsigned int crc6 = crc32(test6, 43);
    test_printstr("  long: ");
    test_printhex(crc6);
    TEST_ASSERT(crc6 == 0x414FA339);
    test_printstr(" OK\n");
    
    test_printstr("All CRC32 tests passed!\n");
    test_pass();
    return 0;
}
