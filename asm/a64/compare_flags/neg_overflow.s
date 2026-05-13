/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000A0000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000090000000",
    "X3": "0x0000000090000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // NEG (Negate) with flags - NEG alias for SUB
    // ========================================

    // Test 0: NEG basic
    mov x10, #5
    neg x11, x10            // x11 = 0 - 5 = -5
    subs x12, x11, #0       // check negative
    mrs x0, nzcv            // Expected: N=1

    // Test 1: NEGS (negate and set flags)
    mov x10, #0
    negs x11, x10           // 0 - 0 = 0
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: NEGS overflow (INT_MIN)
    mov x10, #1
    lsl x10, x10, #63       // x10 = INT64_MIN
    negs x11, x10           // 0 - INT64_MIN = overflow, result = INT64_MIN
    mrs x2, nzcv            // Expected: N=1, V=1

    // Test 3: NEGS 32-bit
    mov w10, #0x80000000    // INT32_MIN
    negs w11, w10           // 0 - INT32_MIN = overflow (32-bit)
    mrs x3, nzcv            // Expected: N=1, V=1

    brk #0