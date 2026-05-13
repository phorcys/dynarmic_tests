/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000040000000",
    "X2": "0x0000000080000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
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
    // BICS instruction tests (Bit Clear NOT)
    // BICS Xd, Xn, Xm: Xd = Xn & NOT(Xm), sets flags
    // ========================================

    // Test 0: BICS with all ones in first operand
    // x10 = all ones, x11 = all zeros
    // BICS: all_ones & NOT(0) = all_ones & all_ones = all_ones, N=1
    mvn x10, xzr                 // x10 = all ones
    mov x11, xzr                 // x11 = 0
    bics x12, x10, x11           // all_ones & NOT(0) = all_ones, N=1
    mrs x0, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 1: BICS resulting in zero
    // 0 & NOT(all_ones) = 0 & 0 = 0, Z=1
    mov x10, xzr
    mvn x11, xzr                 // x11 = all ones
    bics x12, x10, x11           // 0 & NOT(all_ones) = 0 & 0 = 0, Z=1
    mrs x1, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 2: BICS with sign bit
    mov x10, #1
    lsl x10, x10, #63            // sign bit
    mov x11, #0
    bics x12, x10, x11           // sign_bit & NOT(0) = sign_bit, N=1
    mrs x2, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 3: BICS clearing a bit
    mov x10, #0xFF
    mov x11, #0x0F
    bics x12, x10, x11           // 0xFF & NOT(0x0F) = 0xFF & 0xF0 = 0xF0, Z=0, N=0
    mrs x3, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 4: BICS with shifted register
    mov x10, #0xFF00
    mov x11, #0xF
    bics x12, x10, x11, lsl #8   // 0xFF00 & NOT(0xF00) = 0xFF00 & 0xFFFFF0FF = 0xF000
    mrs x4, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 5: BICS with sign bit in result
    mov x10, #1
    lsl x10, x10, #63            // sign bit
    mov x11, #1
    bics x12, x10, x11           // sign_bit & NOT(1) = sign_bit & all_ones_except_1 = still has sign bit, N=1
    mrs x5, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    brk #0