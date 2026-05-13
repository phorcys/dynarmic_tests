/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000A0000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000060000000",
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
    // MOVK with flags verification
    // ========================================

    // Test 0: MOVK zero extension
    movz x10, #0x1234
    movk x10, #0x5678, lsl #16
    movk x10, #0x9ABC, lsl #32
    movk x10, #0xDEF0, lsl #48
    // x10 = 0xDEF09ABC56781234
    subs x11, x10, #0       // check non-zero
    mrs x0, nzcv            // Expected: N=1

    // Test 1: MOVK overwriting
    movz x10, #0xFFFF
    movk x10, #0, lsl #0    // overwrite lower 16 bits
    subs x11, x10, #0
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: MOVK with positive value
    movz x10, #0
    movk x10, #0x1234, lsl #16
    movz x11, #0x1234
    lsl x11, x11, #16
    subs x12, x10, x11
    mrs x2, nzcv            // Expected: Z=1, C=1

    // Test 3: MOVK with negative sign bit
    movz x10, #0
    movk x10, #0x8000, lsl #48   // set sign bit
    subs x11, x10, #0      // N=1 because bit 63 is set
    mrs x3, nzcv            // Expected: N=1

    brk #0