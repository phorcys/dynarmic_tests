// Bit Manipulation Test
// Tests: Various bit manipulation operations
#include "test_syscall.h"

unsigned int count_bits(unsigned int n) {
    unsigned int count = 0;
    while (n) {
        count += n & 1;
        n >>= 1;
    }
    return count;
}

unsigned int reverse_bits(unsigned int n) {
    unsigned int result = 0;
    for (int i = 0; i < 32; i++) {
        result = (result << 1) | (n & 1);
        n >>= 1;
    }
    return result;
}

unsigned int rotate_left(unsigned int n, int shift) {
    shift &= 31;
    return (n << shift) | (n >> (32 - shift));
}

unsigned int rotate_right(unsigned int n, int shift) {
    shift &= 31;
    return (n >> shift) | (n << (32 - shift));
}

unsigned int next_power_of_2(unsigned int n) {
    n--;
    n |= n >> 1;
    n |= n >> 2;
    n |= n >> 4;
    n |= n >> 8;
    n |= n >> 16;
    return n + 1;
}

int is_power_of_2(unsigned int n) {
    return n && !(n & (n - 1));
}

int test_main(void) {
    test_printstr("Testing Bit Manipulation...\n");
    
    // Test 1: Count bits
    test_printstr("  count: ");
    TEST_ASSERT(count_bits(0) == 0);
    TEST_ASSERT(count_bits(1) == 1);
    TEST_ASSERT(count_bits(7) == 3);
    TEST_ASSERT(count_bits(0xFFFFFFFF) == 32);
    test_printstr("OK\n");
    
    // Test 2: Reverse bits
    test_printstr("  reverse: ");
    TEST_ASSERT(reverse_bits(1) == 0x80000000);
    TEST_ASSERT(reverse_bits(0x80000000) == 1);
    TEST_ASSERT(reverse_bits(0xF0F0F0F0) == 0x0F0F0F0F);
    test_printstr("OK\n");
    
    // Test 3: Rotate left
    test_printstr("  rotl: ");
    TEST_ASSERT(rotate_left(1, 1) == 2);
    TEST_ASSERT(rotate_left(1, 31) == 0x80000000);
    TEST_ASSERT(rotate_left(0x80000000, 1) == 1);
    test_printstr("OK\n");
    
    // Test 4: Rotate right
    test_printstr("  rotr: ");
    TEST_ASSERT(rotate_right(2, 1) == 1);
    TEST_ASSERT(rotate_right(1, 1) == 0x80000000);
    TEST_ASSERT(rotate_right(0x80000000, 31) == 1);
    test_printstr("OK\n");
    
    // Test 5: Next power of 2
    test_printstr("  nextpow2: ");
    TEST_ASSERT(next_power_of_2(1) == 1);
    TEST_ASSERT(next_power_of_2(5) == 8);
    TEST_ASSERT(next_power_of_2(1023) == 1024);
    TEST_ASSERT(next_power_of_2(1024) == 1024);
    test_printstr("OK\n");
    
    // Test 6: Is power of 2
    test_printstr("  ispow2: ");
    TEST_ASSERT(is_power_of_2(1));
    TEST_ASSERT(is_power_of_2(2));
    TEST_ASSERT(is_power_of_2(4));
    TEST_ASSERT(is_power_of_2(1024));
    TEST_ASSERT(!is_power_of_2(0));
    TEST_ASSERT(!is_power_of_2(3));
    TEST_ASSERT(!is_power_of_2(5));
    test_printstr("OK\n");
    
    test_printstr("All Bit Manipulation tests passed!\n");
    test_pass();
    return 0;
}
