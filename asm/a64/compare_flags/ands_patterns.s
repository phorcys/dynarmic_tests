/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000",
    "X1": "0x0000000040000000",
    "X2": "0x0000000080000000",
    "X3": "0x0000000000000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // ANDS with various patterns
    // Note: ANDS only updates N and Z flags, C and V are preserved
    // ========================================

    // Test 0: ANDS result zero (Z=1)
    mov x10, #0
    movz x11, #0xFFFF
    movk x11, #0xFFFF, lsl #16
    movk x11, #0xFFFF, lsl #32
    movk x11, #0xFFFF, lsl #48
    ands x12, x10, x11      // 0 & 0xFFFF... = 0
    mrs x0, nzcv            // Expected: Z=1, C=1 (preserved from previous)

    // Test 1: ANDS result zero again
    mov x10, #1
    lsl x10, x10, #63       // x10 = 0x8000000000000000
    mov x11, #0
    ands x12, x10, x11      // anything & 0 = 0
    mrs x1, nzcv            // Expected: Z=1, C=1 (preserved)

    // Test 2: ANDS result negative (N=1)
    mov x10, #1
    lsl x10, x10, #63       // x10 = 0x8000000000000000
    movz x11, #0xFFFF
    movk x11, #0xFFFF, lsl #16
    movk x11, #0xFFFF, lsl #32
    movk x11, #0xFFFF, lsl #48
    ands x12, x10, x11      // 0x8000... & 0xFFFF... = 0x8000...
    mrs x2, nzcv            // Expected: N=1

    // Test 3: ANDS with immediate
    mov x10, #0xFF
    ands x11, x10, #0xFF    // result = 0xFF (not zero, positive)
    mrs x3, nzcv            // Expected: no flags set

    brk #0