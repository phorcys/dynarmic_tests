/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000090000000",
    "X1": "0x0000000030000000",
    "X2": "0x0000000000000000",
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
    // Overflow and edge cases
    // ========================================

    // Test 0: 64-bit signed overflow (positive to negative)
    mov x10, #0x7FFFFFFF
    lsl x10, x10, #32        // x10 = 0x7FFFFFFF00000000
    orr x10, x10, #0xFFFFFFFF
    // x10 = 0x7FFFFFFFFFFFFFFF (INT64_MAX)
    mov x11, #1
    adds x12, x10, x11       // INT64_MAX + 1 = INT64_MIN (overflow)
    mrs x0, nzcv             // Expected: N=1, C=1, V=1 (0x90000000)

    // Test 1: 64-bit signed overflow (negative to positive)
    mov x10, #1
    lsl x10, x10, #63        // x10 = INT64_MIN (0x8000000000000000)
    mov x11, #1
    neg x11, x11             // x11 = -1
    adds x12, x10, x11       // INT64_MIN + (-1) = INT64_MAX (overflow)
    mrs x1, nzcv             // Expected: C=1, V=1 (0x30000000)

    // Test 2: Zero minus -1
    mov x10, #0
    mov x11, #1
    neg x11, x11             // x11 = -1 (all 1s)
    subs x12, x10, x11       // 0 - (-1) = 1
    mrs x2, nzcv             // Expected: N=0, Z=0, C=0, V=0 (0x00000000)

    // Test 3: Maximum unsigned add
    mov x10, #0xFFFFFFFF
    lsl x10, x10, #32
    orr x10, x10, #0xFFFFFFFF  // x10 = UINT64_MAX
    mov x11, #1
    adds x12, x10, x11       // UINT64_MAX + 1 = 0 (carry)
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0