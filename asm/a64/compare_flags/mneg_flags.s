/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000A0000000",
    "X1": "0x00000000A0000000",
    "X2": "0x00000000A0000000",
    "X3": "0x00000000A0000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Multiply-subtract (MNEG) - alias for MSUB
    // MNEG Xd, Xn, Xm = Xd = -Xn * Xm
    // ========================================

    // Test 0: MNEG basic
    mov x10, #5
    mov x11, #3
    mneg x12, x10, x11      // x12 = -5 * 3 = -15
    subs x13, x12, #0       // check negative
    mrs x0, nzcv            // Expected: N=1

    // Test 1: MNEG with negative result
    mov x10, #1
    lsl x10, x10, #63       // x10 = INT64_MIN
    mov x11, #1
    mneg x12, x10, x11      // x12 = -INT64_MIN = overflow
    subs x13, x12, #0
    mrs x1, nzcv            // Expected: N=1 (result is INT64_MIN)

    // Test 2: MNEG 32-bit
    mov w10, #100
    mov w11, #5
    mneg w12, w10, w11      // w12 = -100 * 5 = -500
    subs w13, w12, #0       // check negative
    mrs x2, nzcv            // Expected: N=1

    // Test 3: SMNEGL (signed multiply negate long)
    movz w10, #0xFFFF
    movk w10, #0x7FFF, lsl #16  // w10 = INT32_MAX
    mov w11, #2
    smnegl x12, w10, w11    // x12 = -INT32_MAX * 2 = -0xFFFFFFFE
    subs x13, x12, #0
    mrs x3, nzcv            // Expected: N=1

    brk #0