/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000",
    "X1": "0x80000000",
    "X2": "0x00000000",
    "X3": "0x80000000",
    "X4": "0x00000000",
    "X5": "0x60000000",
    "X6": "0x00000000",
    "X7": "0x90000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // ADDS (extended register) - Add with flags using extended register
    // ADDS Xd, Xn, Rm, extend {, #shift}
    // 
    // Extend options: UXTB, UXTH, UXTW, UXTX, SXTB, SXTH, SXTW, SXTX
    // Shift can be 0 or LSL #amount (varies by extend type)
    // ========================================

    // Test 0: ADDS with UXTB (unsigned extend byte)
    // Add byte from w11 (0xFF = 255) to x10 (0)
    mov x10, #0
    mov w11, #0xFF
    adds x12, x10, w11, uxtb     // 0 + 255 = 255
    mrs x0, nzcv                 // Expected: N=0, Z=0, C=0, V=0

    // Test 1: ADDS with SXTB (signed extend byte)
    // Sign extend 0x80 byte = -128
    mov x10, #0
    mov w11, #0x80
    adds x12, x10, w11, sxtb     // 0 + (-128) = -128
    mrs x1, nzcv                 // Expected: N=1, Z=0, C=0, V=0

    // Test 2: ADDS with UXTH (unsigned extend halfword)
    mov x10, #0
    mov w11, #0xFFFF
    adds x12, x10, w11, uxth     // 0 + 65535 = 65535
    mrs x2, nzcv                 // Expected: N=0, Z=0, C=0, V=0

    // Test 3: ADDS with SXTH (signed extend halfword)
    // Sign extend 0x8000 halfword = -32768
    mov x10, #0
    mov w11, #0x8000
    adds x12, x10, w11, sxth     // 0 + (-32768) = -32768
    mrs x3, nzcv                 // Expected: N=1, Z=0, C=0, V=0

    // Test 4: ADDS with UXTW + LSL #2
    mov x10, #0
    mov w11, #1
    adds x12, x10, w11, uxtw #2  // 0 + (1 << 2) = 4
    mrs x4, nzcv                 // Expected: N=0, Z=0, C=0, V=0

    // Test 5: ADDS with SXTW (sign extend word to 64-bit)
    // 32-bit -1 sign-extended to 64-bit is still -1
    mov x10, #1
    mov w11, #0xFFFFFFFF
    adds x12, x10, w11, sxtw     // 1 + (-1) = 0
    mrs x5, nzcv                 // Expected: N=0, Z=1, C=1, V=0

    // Test 6: ADDS with UXTW (unsigned extend word)
    // Zero-extend 32-bit value to 64-bit
    mov x10, #0
    mov w11, #1
    adds x12, x10, w11, uxtw     // 0 + 1 = 1
    mrs x6, nzcv                 // Expected: N=0, Z=0, C=0, V=0

    // Test 7: ADDS with SXTW causing overflow
    mov x10, #0x7FFFFFFFFFFFFFFF  // MAX_INT64
    mov w11, #1
    adds x12, x10, w11, sxtw     // MAX_INT64 + 1 = overflow
    mrs x7, nzcv                 // Expected: N=1, Z=0, C=1, V=1

    brk #0