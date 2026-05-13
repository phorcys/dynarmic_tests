/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000",
    "X1": "0x70000000",
    "X2": "0x00000000",
    "X3": "0xA0000000"
  }
}
*/
// Test: ADDS with shift (64-bit)
// ADDS Xd, Xn, Xm, LSL #n
// ADDS Xd, Xn, Xm, LSR #n
// ADDS Xd, Xn, Xm, ASR #n

.text
.global _start
_start:
    // Test 1: ADDS with LSL #4
    // 1 + (1 << 4) = 1 + 16 = 17
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov x10, #1
    mov x11, #1
    adds x12, x10, x11, lsl #4
    mrs x0, nzcv

    // Test 2: ADDS with LSL causing carry and overflow
    // 0x8000000000000000 + (1 << 63) = 0 (with carry, overflow)
    // N=0, Z=1, C=1, V=1 -> NZCV = 0x70000000
    mov x10, #1
    lsl x10, x10, #63    // x10 = 0x8000000000000000
    mov x11, #1
    adds x12, x10, x11, lsl #63  // 0x8000000000000000 + 0x8000000000000000
    mrs x1, nzcv

    // Test 3: ADDS with LSR
    // 0x100 + (0x200 >> 4) = 0x100 + 0x20 = 0x120
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    mov x10, #0x100
    mov x11, #0x200
    adds x12, x10, x11, lsr #4
    mrs x2, nzcv

    // Test 4: ADDS with ASR (arithmetic shift right)
    // -16 + (-8 >> 1) = -16 + -4 = -20
    // N=1, Z=0, C=1 (both operands negative, sum is negative, but with carry)
    // Let me recalculate: -16 is 0xFFFFFFFFFFFFFFF0, -8 is 0xFFFFFFFFFFFFFFF8
    // -8 >> 1 = 0xFFFFFFFFFFFFFFFC = -4
    // -16 + (-4) = -20 = 0xFFFFFFFFFFFFFFEC
    // For addition of two negatives: C = (result < a) = (0xEC < 0xF0) = 1
    // N=1, Z=0, C=1, V=0 -> NZCV = 0xA0000000
    mov x10, #-16
    mov x11, #-8
    adds x12, x10, x11, asr #1
    mrs x3, nzcv

    brk #0
