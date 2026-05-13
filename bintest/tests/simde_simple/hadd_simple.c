// Simple test for halving add - uses volatile to prevent constant folding
#include "test_syscall.h"
#include <arm_neon.h>

// Volatile pointers to force runtime evaluation
volatile uint8_t va[8] = {255, 128, 64, 32, 16, 8, 4, 2};
volatile uint8_t vb[8] = {1, 128, 65, 33, 17, 9, 5, 3};

char hexbuf[32];

void print_hex(const char* label, uint8_t* data, int len) {
    char* p = hexbuf;
    while (*label) *p++ = *label++;
    *p++ = ':';
    *p++ = ' ';
    for (int i = 0; i < len; i++) {
        int hi = (data[i] >> 4) & 0xf;
        int lo = data[i] & 0xf;
        *p++ = hi < 10 ? '0' + hi : 'a' + hi - 10;
        *p++ = lo < 10 ? '0' + lo : 'a' + lo - 10;
        *p++ = ' ';
    }
    *p++ = '\n';
    sys_write(1, hexbuf, p - hexbuf);
}

int test_main(void) {
    // Load from volatile to prevent constant folding
    uint8x8_t a = vld1_u8((const uint8_t*)va);
    uint8x8_t b = vld1_u8((const uint8_t*)vb);
    uint8x8_t expected = {128, 128, 64, 32, 16, 8, 4, 2};
    
    print_hex("Input a", (uint8_t*)&a, 8);
    print_hex("Input b", (uint8_t*)&b, 8);
    
    uint8x8_t result = vhadd_u8(a, b);
    
    print_hex("Result ", (uint8_t*)&result, 8);
    print_hex("Expect ", (uint8_t*)&expected, 8);
    
    int pass = 1;
    for (int i = 0; i < 8; i++) {
        if (result[i] != expected[i]) {
            sys_write(1, "FAIL: vhadd_u8 mismatch\n", 24);
            pass = 0;
            break;
        }
    }
    
    if (pass) {
        sys_write(1, "PASS: vhadd_u8\n", 15);
    }
    
    sys_exit(pass ? 0 : 1);
    return 0;
}
