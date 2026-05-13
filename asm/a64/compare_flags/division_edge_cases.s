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
    // Division edge cases with flags
    // ========================================

    // Test 0: SDIV positive / positive
    mov x10, #100
    mov x11, #7
    sdiv x12, x10, x11       // 100 / 7 = 14
    subs x13, x12, #14
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: SDIV negative / positive
    mov x10, #100
    neg x10, x10             // x10 = -100
    mov x11, #7
    sdiv x12, x10, x11       // -100 / 7 = -14
    mov x13, #14
    neg x13, x13
    subs x14, x12, x13
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: UDIV large / small
    mov x10, #1000
    mov x11, #7
    udiv x12, x10, x11       // 1000 / 7 = 142
    subs x13, x12, #142
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: Division by zero (should return 0)
    mov x10, #100
    mov x11, #0
    udiv x12, x10, x11       // 100 / 0 = 0 (architecture defined)
    subs x13, x12, #0
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0
