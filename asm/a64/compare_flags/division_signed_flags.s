/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000A0000000",
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
    // Signed division edge cases with flags
    // ========================================

    // Test 0: SDIV of INT64_MIN by -1
    mov x10, #1
    lsl x10, x10, #63        // x10 = INT64_MIN
    mov x11, #1
    neg x11, x11             // x11 = -1
    sdiv x12, x10, x11       // INT64_MIN / -1 = overflow, returns INT64_MIN
    subs x13, x12, #0
    mrs x0, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 1: SDIV positive by positive
    mov x10, #100
    mov x11, #7
    sdiv x12, x10, x11       // 100 / 7 = 14 (truncated)
    subs x13, x12, #14
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: SDIV negative by positive
    mov x10, #100
    neg x10, x10             // x10 = -100
    mov x11, #7
    sdiv x12, x10, x11       // -100 / 7 = -14 (truncated toward zero)
    mov x13, #14
    neg x13, x13
    subs x14, x12, x13
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: UDIV by zero
    mov x10, #100
    mov x11, #0
    udiv x12, x10, x11       // 100 / 0 = 0 (defined behavior)
    subs x13, x12, #0
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0