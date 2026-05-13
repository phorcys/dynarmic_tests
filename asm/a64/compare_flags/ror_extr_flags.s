/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000040000000",
    "X2": "0x0000000040000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000080000000",
    "X5": "0x0000000080000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Misc flag tests (EXTR, BICS, ORN)
    // ========================================

    // Test 0: EXTR with flags check - extract high 32 bits of 0xFFFFFFFFFFFFFFFF
    mov x10, #0xFFFFFFFF
    movk x10, #0xFFFF, lsl #16
    movk x10, #0xFFFF, lsl #32
    movk x10, #0xFFFF, lsl #48
    mov x11, #0
    extr x12, x10, x11, #32      // Extract bits 63:32 from x10 -> 0xFFFFFFFF
    adds x13, x12, xzr           // 0xFFFFFFFF is positive in 32-bit but sign-extended to 64-bit
    mrs x0, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 1: EXTR with zero result
    mov x10, #0
    mov x11, #0
    extr x12, x10, x11, #0       // Extract bits 63:0 from x10:x11
    adds x13, x12, xzr
    mrs x1, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 2: BICS with zero result
    mov x10, #0xF0
    mov x11, #0x0F
    bics x12, x10, x11, lsl #4   // 0xF0 & ~(0x0F << 4) = 0xF0 & ~0xF0 = 0
    mrs x2, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 3: BICS with non-zero result (positive)
    mov x10, #0xFE
    mov x11, #0x01
    bics x12, x10, x11           // 0xFE & ~0x01 = 0xFE (positive, bit 7 = 0)
    mrs x3, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 4: ORN then ANDS for negative
    mov x10, #0
    orn x12, x10, xzr            // x12 = 0 | ~0 = ~0 = all 1s
    ands x13, x12, x12           // All 1s, N=1
    mrs x4, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 5: MVN alias for ORN with zero
    mvn x12, xzr                 // x12 = ~0 = all 1s
    mov x10, #1
    lsl x10, x10, #63            // Sign bit
    ands x13, x12, x10           // AND with sign bit
    mrs x5, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    brk #0
