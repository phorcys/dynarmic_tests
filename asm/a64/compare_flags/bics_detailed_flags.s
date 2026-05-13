/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x40000000",
    "X1": "0x40000000",
    "X2": "0x80000000",
    "X3": "0x00000000",
    "X4": "0x40000000",
    "X5": "0x80000000",
    "X6": "0x00000000",
    "X7": "0x00000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // BICS (shifted register) - Bitwise Bit Clear with flags
    // BICS Xd, Xn, Rm, shift #amount
    // d = n AND (NOT m)
    // 
    // N = result < 0 (bit 63 for 64-bit, bit 31 for 32-bit)
    // Z = result == 0
    // C = 0 (always)
    // V = 0 (always)
    // ========================================

    // Test 0: BICS clearing all bits
    mov x10, #0xFF
    mov x11, #0xFF
    bics x12, x10, x11           // 0xFF & ~0xFF = 0
    mrs x0, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 1: BICS with input zero
    mov x10, #0
    mov x11, #0xFF
    bics x12, x10, x11           // 0 & ~0xFF = 0
    mrs x1, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 2: BICS with negative result (bit 63)
    mov x10, #1
    lsl x10, x10, #63            // bit 63 set
    mov x11, #0                  // clear nothing
    bics x12, x10, x11           // keeps bit 63
    mrs x2, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 3: BICS with LSL shift
    mov x10, #0xFF00
    mov x11, #0xF
    lsl x11, x11, #8             // 0xF00
    bics x12, x10, x11           // 0xFF00 & ~0xF00 = 0xF000
    mrs x3, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 4: BICS 32-bit with zero result
    mov w10, #0xFF
    mov w11, #0xFF
    bics w12, w10, w11           // 0xFF & ~0xFF = 0
    mrs x4, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 5: BICS 32-bit with negative result (bit 31)
    mov w10, #0x80000000
    mov w11, #0
    bics w12, w10, w11           // keeps bit 31
    mrs x5, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 6: BICS with LSR shift
    mov x10, #0xFFFF
    mov x11, #0xFF
    lsr x11, x11, #4             // 0xF
    bics x12, x10, x11           // 0xFFFF & ~0xF = 0xFFF0
    mrs x6, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 7: BICS 64-bit with positive result
    mov x10, #0x80000000         // Only bit 31 set (positive in 64-bit)
    mov x11, #0
    bics x12, x10, x11           // 0x80000000 & ~0 = 0x80000000 (positive in 64-bit)
    mrs x7, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    brk #0
