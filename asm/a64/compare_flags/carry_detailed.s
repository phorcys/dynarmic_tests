/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000090000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000080000000",
    "X3": "0x0000000020000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Carry flag detailed tests
    // ========================================

    // Test 0: ADDS 32-bit max + 1 (signed overflow)
    mov w10, #0x7FFFFFFF
    mov w11, #1
    adds w12, w10, w11       // 0x7FFFFFFF + 1 = 0x80000000 (32-bit signed overflow)
    mrs x0, nzcv             // Expected: N=1, C=1, V=1 (0x90000000)

    // Test 1: ADDS 32-bit all ones + 1
    mov w10, #0xFFFF
    lsl w10, w10, #16
    orr w10, w10, #0xFFFF    // w10 = 0xFFFFFFFF
    mov w11, #1
    adds w12, w10, w11       // 0xFFFFFFFF + 1 = 0 (carry)
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: SUBS carry semantics (borrow)
    mov x10, #5
    mov x11, #10
    subs x12, x10, x11       // 5 - 10 = -5 (borrow, C=0)
    mrs x2, nzcv             // Expected: N=1 (0x80000000)

    // Test 3: SUBS carry semantics (no borrow)
    mov x10, #10
    mov x11, #5
    subs x12, x10, x11       // 10 - 5 = 5 (no borrow, C=1)
    mrs x3, nzcv             // Expected: C=1 (0x20000000)

    brk #0
