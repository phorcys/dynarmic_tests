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
    // DIV (Division) flags tests
    // SDIV/UDIV do NOT set flags directly
    // But we test the result with SUBS to verify correctness
    // ========================================

    // Test 0: UDIV basic
    mov x10, #100
    mov x11, #5
    udiv x12, x10, x11    // 100 / 5 = 20
    subs x13, x12, #20
    mrs x0, nzcv          // Expected: Z=1, C=1

    // Test 1: SDIV basic positive
    mov x10, #100
    mov x11, #5
    sdiv x12, x10, x11    // 100 / 5 = 20
    subs x13, x12, #20
    mrs x1, nzcv          // Expected: Z=1, C=1

    // Test 2: SDIV with negative dividend
    mov x10, #-100
    mov x11, #5
    sdiv x12, x10, x11    // -100 / 5 = -20
    mov x13, #-20
    subs x14, x12, x13    // verify
    mrs x2, nzcv          // Expected: Z=1, C=1

    // Test 3: SDIV with negative divisor
    mov x10, #100
    mov x11, #-5
    sdiv x12, x10, x11    // 100 / -5 = -20
    mov x13, #-20
    subs x14, x12, x13    // verify
    mrs x3, nzcv          // Expected: Z=1, C=1

    brk #0
