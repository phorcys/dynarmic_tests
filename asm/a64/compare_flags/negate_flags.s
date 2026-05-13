/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000A0000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000090000000",
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
    // NEG/NGS (negate with flags)
    // ========================================

    // Test 0: NEG (alias for SUB with zero)
    mov x10, #42
    neg x11, x10             // x11 = -42
    subs x12, x11, #0
    mrs x0, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 1: NEGS (negate and set flags)
    mov x10, #1
    negs x11, x10            // -1, sets flags
    mrs x1, nzcv             // Expected: N=1 (0x80000000)

    // Test 2: NEGS of INT64_MIN
    mov x10, #1
    lsl x10, x10, #63        // x10 = INT64_MIN
    negs x11, x10            // -INT64_MIN = INT64_MIN (overflow)
    mrs x2, nzcv             // Expected: N=1, C=1, V=1 (0x90000000)

    // Test 3: NEGS of zero
    mov x10, #0
    negs x11, x10            // -0 = 0
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0