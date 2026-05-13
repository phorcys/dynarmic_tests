// Test big integer operations (simulated)
#include "test_syscall.h"

// 64-bit multiply returning high 32 bits
unsigned int mul_high32(unsigned int a, unsigned int b) {
    unsigned long long prod = (unsigned long long)a * b;
    return (unsigned int)(prod >> 32);
}

// 64-bit multiply returning low 32 bits
unsigned int mul_low32(unsigned int a, unsigned int b) {
    unsigned long long prod = (unsigned long long)a * b;
    return (unsigned int)prod;
}

// 64-bit addition with carry
unsigned int add_with_carry(unsigned int a, unsigned int b, int carry_in, int* carry_out) {
    unsigned long long sum = (unsigned long long)a + b + carry_in;
    *carry_out = (sum >> 32) ? 1 : 0;
    return (unsigned int)sum;
}

// 64-bit subtraction with borrow
unsigned int sub_with_borrow(unsigned int a, unsigned int b, int borrow_in, int* borrow_out) {
    unsigned long long diff = (unsigned long long)a - b - borrow_in;
    *borrow_out = (diff >> 32) ? 1 : 0;
    return (unsigned int)diff;
}

// Multiply two 64-bit numbers (each as two 32-bit parts)
void mul_64x64(unsigned int a_hi, unsigned int a_lo,
               unsigned int b_hi, unsigned int b_lo,
               unsigned int* r0, unsigned int* r1, unsigned int* r2, unsigned int* r3) {
    // r = a * b (128-bit result in 4 x 32-bit parts)
    // Simplified: just compute a_lo * b_lo
    unsigned long long prod = (unsigned long long)a_lo * b_lo;
    *r0 = (unsigned int)prod;
    *r1 = (unsigned int)(prod >> 32);
    *r2 = 0;
    *r3 = 0;
    
    // Add a_lo * b_hi to r2:r1
    prod = (unsigned long long)a_lo * b_hi;
    int carry;
    *r1 = add_with_carry(*r1, (unsigned int)prod, 0, &carry);
    *r2 = add_with_carry(*r2, (unsigned int)(prod >> 32), carry, &carry);
    *r3 += carry;
    
    // Add a_hi * b_lo to r2:r1
    prod = (unsigned long long)a_hi * b_lo;
    *r1 = add_with_carry(*r1, (unsigned int)prod, 0, &carry);
    *r2 = add_with_carry(*r2, (unsigned int)(prod >> 32), carry, &carry);
    *r3 += carry;
}

int test_main(void) {
    test_printstr("Testing big integer ops...\n");
    
    // Test 1: Multiply high 32 bits
    unsigned int h1 = mul_high32(0x10000, 0x10000);
    test_printstr("  mul_hi: ");
    test_printhex(h1);
    TEST_ASSERT(h1 == 1);
    test_printstr(" OK\n");
    
    // Test 2: Multiply low 32 bits
    unsigned int l1 = mul_low32(0x10001, 0x10001);
    test_printstr("  mul_lo: ");
    test_printhex(l1);
    TEST_ASSERT(l1 == 0x20001);
    test_printstr(" OK\n");
    
    // Test 3: Add with carry (no carry)
    int carry;
    unsigned int s1 = add_with_carry(100, 200, 0, &carry);
    test_printstr("  add_nc: ");
    TEST_ASSERT(s1 == 300);
    TEST_ASSERT(carry == 0);
    test_printstr("OK\n");
    
    // Test 4: Add with carry (with carry)
    unsigned int s2 = add_with_carry(0xFFFFFFFF, 1, 0, &carry);
    test_printstr("  add_c: ");
    TEST_ASSERT(s2 == 0);
    TEST_ASSERT(carry == 1);
    test_printstr("OK\n");
    
    // Test 5: Subtract with borrow
    int borrow;
    unsigned int d1 = sub_with_borrow(100, 50, 0, &borrow);
    test_printstr("  sub_nb: ");
    TEST_ASSERT(d1 == 50);
    TEST_ASSERT(borrow == 0);
    test_printstr("OK\n");
    
    // Test 6: Subtract with borrow (needs borrow)
    unsigned int d2 = sub_with_borrow(50, 100, 0, &borrow);
    test_printstr("  sub_b: ");
    TEST_ASSERT(d2 == (unsigned int)(0 - 50));  // underflow
    TEST_ASSERT(borrow == 1);
    test_printstr("OK\n");
    
    // Test 7: 64x64 multiply
    unsigned int r0, r1, r2, r3;
    mul_64x64(0, 0x10000, 0, 0x10000, &r0, &r1, &r2, &r3);
    test_printstr("  mul64: ");
    test_printhex(r1);
    test_printstr(",");
    test_printhex(r0);
    TEST_ASSERT(r0 == 0);      // low 32 bits
    TEST_ASSERT(r1 == 1);      // high 32 bits of low 64
    test_printstr(" OK\n");
    
    test_printstr("All big integer tests passed!\n");
    test_pass();
    return 0;
}
