// Test bitwise operations and algorithms
#include "test_syscall.h"

int popcount(unsigned int x) {
    int count = 0;
    while (x) {
        count += x & 1;
        x >>= 1;
    }
    return count;
}

int clz(unsigned int x) {
    if (x == 0) return 32;
    int n = 0;
    while ((x & (1u << 31)) == 0) {
        x <<= 1;
        n++;
    }
    return n;
}

int ctz(unsigned int x) {
    if (x == 0) return 32;
    int n = 0;
    while ((x & 1) == 0) {
        x >>= 1;
        n++;
    }
    return n;
}

unsigned int bswap(unsigned int x) {
    return ((x & 0xFF) << 24) |
           ((x & 0xFF00) << 8) |
           ((x & 0xFF0000) >> 8) |
           ((x & 0xFF000000) >> 24);
}

int is_power_of_2(unsigned int x) {
    return x != 0 && (x & (x - 1)) == 0;
}

unsigned int next_power_of_2(unsigned int x) {
    if (x == 0) return 1;
    x--;
    x |= x >> 1;
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;
    return x + 1;
}

int test_main(void) {
    test_printstr("Testing bitwise algorithms...\n");
    
    // Test 1: Population count
    int c = popcount(0xFF);
    test_printstr("  popcount(0xFF) = ");
    test_printint(c);
    TEST_ASSERT(c == 8);
    
    c = popcount(0xAAAAAAAA);
    test_printstr("\n  popcount(0xAAAAAAAA) = ");
    test_printint(c);
    TEST_ASSERT(c == 16);
    
    // Test 2: Count leading zeros
    c = clz(0x80000000);
    test_printstr("\n  clz(0x80000000) = ");
    test_printint(c);
    TEST_ASSERT(c == 0);
    
    c = clz(0x1);
    test_printstr("\n  clz(0x1) = ");
    test_printint(c);
    TEST_ASSERT(c == 31);
    
    // Test 3: Count trailing zeros
    c = ctz(0x1);
    test_printstr("\n  ctz(0x1) = ");
    test_printint(c);
    TEST_ASSERT(c == 0);
    
    c = ctz(0x10);
    test_printstr("\n  ctz(0x10) = ");
    test_printint(c);
    TEST_ASSERT(c == 4);
    
    // Test 4: Byte swap
    unsigned int sw = bswap(0x12345678);
    test_printstr("\n  bswap(0x12345678) = ");
    test_printhex(sw);
    TEST_ASSERT(sw == 0x78563412);
    
    // Test 5: Power of 2 check
    TEST_ASSERT(is_power_of_2(1) == 1);
    TEST_ASSERT(is_power_of_2(2) == 1);
    TEST_ASSERT(is_power_of_2(4) == 1);
    TEST_ASSERT(is_power_of_2(3) == 0);
    TEST_ASSERT(is_power_of_2(6) == 0);
    test_printstr("\n  is_power_of_2: OK\n");
    
    // Test 6: Next power of 2
    unsigned int np = next_power_of_2(5);
    test_printstr("  next_pow2(5) = ");
    test_printint((int)np);
    TEST_ASSERT(np == 8);
    
    np = next_power_of_2(100);
    test_printstr("\n  next_pow2(100) = ");
    test_printint((int)np);
    TEST_ASSERT(np == 128);
    
    test_printstr("\nAll bitwise tests passed!\n");
    test_pass();
    return 0;
}
