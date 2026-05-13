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
    // UMULH/SMULH (high part of multiply)
    // ========================================

    // Test 0: UMULH basic (high 64 bits of 64x64 multiply)
    mov x10, #0
    mov x11, #0
    umulh x12, x10, x11      // 0 * 0 = 0, high = 0
    subs x13, x12, #0
    mrs x0, nzcv             // Expected: Z=1, C=1

    // Test 1: UMULH with small values (high = 0)
    mov x10, #100
    mov x11, #5
    umulh x12, x10, x11      // 100 * 5 = 500, high = 0
    subs x13, x12, #0
    mrs x1, nzcv             // Expected: Z=1, C=1

    // Test 2: UMULH with large values
    // 2^32 * 2^32 = 2^64, low = 0, high = 1
    mov x10, #1
    lsl x10, x10, #32        // x10 = 2^32
    mov x11, #1
    lsl x11, x11, #32        // x11 = 2^32
    umulh x12, x10, x11      // high = 1
    subs x13, x12, #1
    mrs x2, nzcv             // Expected: Z=1, C=1

    // Test 3: SMULH with negative (high part calculation)
    mov x10, #-1             // all 1s
    mov x11, #-1             // all 1s
    smulh x12, x10, x11      // (-1) * (-1) = 1, high = 0
    subs x13, x12, #0
    mrs x3, nzcv             // Expected: Z=1, C=1

    brk #0
