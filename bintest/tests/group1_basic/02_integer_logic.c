/* Test: Integer logical operations */
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing integer logic...\n");
    
    unsigned long a = 0xFF00FF00;
    unsigned long b = 0x0F0F0F0F;
    
    // AND
    unsigned long and_result = a & b;
    TEST_ASSERT(and_result == 0x0F000F00);
    test_printstr("  AND: ");
    test_printhex(and_result);
    test_newline();
    
    // OR
    unsigned long or_result = a | b;
    TEST_ASSERT(or_result == 0xFF0FFF0F);
    test_printstr("  OR: ");
    test_printhex(or_result);
    test_newline();
    
    // XOR
    unsigned long xor_result = a ^ b;
    TEST_ASSERT(xor_result == 0xF00FF00F);
    test_printstr("  XOR: ");
    test_printhex(xor_result);
    test_newline();
    
    // NOT - for 64-bit, need to mask
    unsigned long not_result = ~a;
    unsigned long expected_not = 0xFFFFFFFF00FF00FF;
    TEST_ASSERT(not_result == expected_not);
    test_printstr("  NOT: ");
    test_printhex(not_result);
    test_newline();
    
    // NAND (simulated) - for 64-bit
    unsigned long nand_result = ~(a & b);
    unsigned long expected_nand = 0xFFFFFFFFF0FFF0FF;
    TEST_ASSERT(nand_result == expected_nand);
    
    // NOR (simulated) - for 64-bit
    unsigned long nor_result = ~(a | b);
    unsigned long expected_nor = 0xFFFFFFFF00F000F0;
    TEST_ASSERT(nor_result == expected_nor);
    
    test_printstr("All logic tests passed!\n");
    test_pass();
    return 0;
}
