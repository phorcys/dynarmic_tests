/* Test: Integer shift operations */
#include "test_syscall.h"

int test_main(void) {
    test_printstr("Testing integer shifts...\n");
    
    uint64_t a = 0x12345678ULL;
    
    // Logical left shift - 64-bit result
    uint64_t lsl_result = a << 4;
    TEST_ASSERT(lsl_result == 0x123456780ULL);
    test_printstr("  LSL: ");
    test_printhex(lsl_result);
    test_newline();
    
    // Logical right shift
    uint64_t lsr_result = a >> 4;
    TEST_ASSERT(lsr_result == 0x01234567ULL);
    test_printstr("  LSR: ");
    test_printhex(lsr_result);
    test_newline();
    
    // Arithmetic right shift (signed)
    long signed_val = -0x1000;  // Negative number
    long asr_result = signed_val >> 4;
    TEST_ASSERT(asr_result < 0);
    test_printstr("  ASR (signed): ");
            test_printint(asr_result);
            test_newline();
            
            // Rotate right (simulated) - for 32-bit value
            unsigned int ror_val = 0x80000001;
            unsigned int ror_result = (ror_val >> 1) | (ror_val << 31);
            test_printstr("  ROR: ");
            test_printhex(ror_result);
            test_newline();
            
            // Zero extend shift
            unsigned char byte_val = 0xFF;
            unsigned long ext_result = (unsigned long)byte_val << 8;
            TEST_ASSERT(ext_result == 0xFF00);
            test_printstr("  Extend+shift: ");
            test_printhex(ext_result);
            test_newline();
            
            test_printstr("All shift tests passed!\n");
            test_pass();
            return 0;
        }
