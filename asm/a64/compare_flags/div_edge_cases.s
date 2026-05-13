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
    // UDIV/SDIV edge cases
    // ========================================

    // Test 0: UDIV by 1
    mov x10, #42
    mov x11, #1
    udiv x12, x10, x11      // 42 / 1 = 42
    subs x13, x12, #42
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: UDIV by 0 (returns 0)
    mov x10, #42
    mov x11, #0
    udiv x12, x10, x11      // 42 / 0 = 0 (defined behavior)
    subs x13, x12, #0
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: SDIV negative by positive
    mov x10, #-42
    mov x11, #6
    sdiv x12, x10, x11      // -42 / 6 = -7
    mov x13, #-7
    subs x14, x12, x13
    mrs x2, nzcv            // Expected: Z=1, C=1

    // Test 3: SDIV positive by negative
    mov x10, #42
    mov x11, #-6
    sdiv x12, x10, x11      // 42 / -6 = -7
    mov x13, #-7
    subs x14, x12, x13
    mrs x3, nzcv            // Expected: Z=1, C=1

    brk #0
