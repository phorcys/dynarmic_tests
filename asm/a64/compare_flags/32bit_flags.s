/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000090000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000080000000",
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
    // 32-bit flag operations
    // ========================================

    // Test 0: ADDS W (32-bit add with flags)
    mov w10, #0x7FFFFFFF     // max positive int32
    mov w11, #1
    adds w12, w10, w11       // overflow
    mrs x0, nzcv             // Expected: N=1, C=1, V=1 (0x90000000)

    // Test 1: SUBS W (32-bit sub with flags)
    mov w10, #0
    mov w11, #1
    subs w12, w10, w11       // 0 - 1 = -1 (unsigned underflow)
    mrs x1, nzcv             // Expected: N=1 (0x80000000)

    // Test 2: 32-bit negative result
    mov w10, #1
    negs w11, w10            // -1 in 32-bit
    mrs x2, nzcv             // Expected: N=1 (0x80000000)

    // Test 3: 32-bit compare
    mov w10, #0x80000000     // INT32_MIN
    mov w11, #0x80000000     // INT32_MIN
    cmp w10, w11             // equal
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0