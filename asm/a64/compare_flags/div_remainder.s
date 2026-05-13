/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x00000000A0000000",
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
    // Unsigned divide remainder (UDIV + MSUB)
    // UDIV doesn't set flags, but remainder calculation can
    // ========================================

    // Test 0: UDIV basic
    mov x10, #20
    mov x11, #4
    udiv x12, x10, x11      // x12 = 20 / 4 = 5
    subs x13, x12, #5
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: UDIV with remainder
    mov x10, #21
    mov x11, #4
    udiv x12, x10, x11      // x12 = 21 / 4 = 5
    msub x13, x12, x11, x10 // x13 = 21 - 5 * 4 = 1 (remainder)
    subs x14, x13, #1
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: SDIV signed
    mov x10, #1
    lsl x10, x10, #63       // x10 = INT64_MIN
    mov x11, #1
    sdiv x12, x10, x11      // x12 = INT64_MIN / 1 = INT64_MIN
    subs x13, x12, #0       // check negative
    mrs x2, nzcv            // Expected: N=1

    // Test 3: Division by zero
    mov x10, #42
    mov x11, #0
    udiv x12, x10, x11      // x12 = 0 (no exception)
    subs x13, x12, #0
    mrs x3, nzcv            // Expected: Z=1, C=1

    brk #0