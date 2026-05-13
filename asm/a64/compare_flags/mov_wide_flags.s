/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000060000000",
    "X3": "0x0000000060000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // MOVK/MOVZ with flags verification
    // MOVK/MOVZ don't set flags, verify with SUBS
    // ========================================

    // Test 0: MOVZ - move wide with zero
    movz x10, #0x1234, lsl #0
    mov x11, #0x1234
    subs x12, x10, x11           // verify equal
    mrs x0, nzcv                 // Expected: Z=1, C=1 = 0x60000000

    // Test 1: MOVZ with shift
    movz x10, #0x5678, lsl #16
    mov x11, #0x5678
    lsl x11, x11, #16
    subs x12, x10, x11           // verify equal
    mrs x1, nzcv                 // Expected: Z=1, C=1 = 0x60000000

    // Test 2: MOVK - keep and insert
    movz x10, #0x1234, lsl #0
    movk x10, #0x5678, lsl #16
    // x10 now = 0x56781234
    movz x11, #0x1234, lsl #0
    movk x11, #0x5678, lsl #16
    subs x12, x10, x11           // verify equal
    mrs x2, nzcv                 // Expected: Z=1, C=1

    // Test 3: MOVN - move wide with NOT
    movn x10, #0, lsl #0         // x10 = 0xFFFFFFFFFFFFFFFF
    mvn x11, xzr                 // x11 = -1 = 0xFFFFFFFFFFFFFFFF
    subs x12, x10, x11           // verify equal
    mrs x3, nzcv                 // Expected: Z=1, C=1

    brk #0
