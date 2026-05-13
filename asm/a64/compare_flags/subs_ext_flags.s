/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x60000000",
    "X1": "0x00000000",
    "X2": "0x20000000",
    "X3": "0x00000000",
    "X4": "0x20000000",
    "X5": "0x00000000",
    "X6": "0x20000000",
    "X7": "0x80000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // SUBS (extended register) - Subtract with flags using extended register
    // SUBS Xd, Xn, Rm, extend {, #shift}
    // 
    // For subtraction: a - b
    // N = result < 0 (signed)
    // Z = result == 0
    // C = a >= b (unsigned, no borrow)
    // V = signed overflow
    // ========================================

    // Test 0: SUBS with UXTB - result zero
    mov x10, #255
    mov w11, #0xFF
    subs x12, x10, w11, uxtb     // 255 - 255 = 0
    mrs x0, nzcv                 // Expected: N=0, Z=1, C=1, V=0

    // Test 1: SUBS with SXTB - subtracting negative
    mov x10, #0
    mov w11, #0x80               // Sign extend to -128
    subs x12, x10, w11, sxtb     // 0 - (-128) = 128
    mrs x1, nzcv                 // Expected: N=0, Z=0, C=1, V=0

    // Test 2: SUBS with UXTH
    mov x10, #0x10000
    mov w11, #1
    subs x12, x10, w11, uxth     // 0x10000 - 1 = 0xFFFF
    mrs x2, nzcv                 // Expected: N=0, Z=0, C=1, V=0

    // Test 3: SUBS with SXTH - subtracting negative halfword
    mov x10, #0
    mov w11, #0x8000             // Sign extend to -32768
    subs x12, x10, w11, sxth     // 0 - (-32768) = 32768
    mrs x3, nzcv                 // Expected: N=0, Z=0, C=1, V=0

    // Test 4: SUBS with UXTW + LSL #2
    mov x10, #16
    mov w11, #1
    subs x12, x10, w11, uxtw #2  // 16 - 4 = 12
    mrs x4, nzcv                 // Expected: N=0, Z=0, C=1, V=0

    // Test 5: SUBS with SXTW - subtracting -1
    mov x10, #0
    mov w11, #0xFFFFFFFF         // Sign extend to -1
    subs x12, x10, w11, sxtw     // 0 - (-1) = 1
    mrs x5, nzcv                 // Expected: N=0, Z=0, C=1, V=0

    // Test 6: SUBS with UXTW - simple subtraction
    mov x10, #100
    mov w11, #50
    subs x12, x10, w11, uxtw     // 100 - 50 = 50
    mrs x6, nzcv                 // Expected: N=0, Z=0, C=1, V=0

    // Test 7: SUBS with SXTW - subtracting 1 from 0
    mov x10, #0
    mov w11, #1
    subs x12, x10, w11, sxtw     // 0 - 1 = -1 (borrow, negative)
    mrs x7, nzcv                 // Expected: N=1, Z=0, C=0, V=0

    brk #0
