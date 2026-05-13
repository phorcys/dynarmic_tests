/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000020000000",
    "X3": "0x0000000080000000",
    "X4": "0x0000000060000000",
    "X5": "0x0000000020000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Carry flag tests (C flag)
    // ========================================

    // Test 0: ADDS 32-bit without carry
    mov w10, #100
    mov w11, #200
    adds w12, w10, w11           // 100 + 200 = 300, no carry
    mrs x0, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 1: ADDS 32-bit with carry
    mov w10, #0xFFFFFFFF
    mov w11, #1
    adds w12, w10, w11           // MAX + 1 = 0 with carry
    mrs x1, nzcv                 // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 2: SUBS 32-bit without borrow (C=1)
    mov w10, #200
    mov w11, #100
    subs w12, w10, w11           // 200 - 100 = 100, no borrow, C=1
    mrs x2, nzcv                 // Expected: N=0, Z=0, C=1, V=0 = 0x20000000

    // Test 3: SUBS 32-bit with borrow (C=0)
    mov w10, #100
    mov w11, #200
    subs w12, w10, w11           // 100 - 200 = -100, borrow, C=0
    mrs x3, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 4: ADDS 64-bit with carry
    mov x10, #0xFFFFFFFF
    movk x10, #0xFFFF, lsl #16
    movk x10, #0xFFFF, lsl #32
    movk x10, #0xFFFF, lsl #48   // MAX uint64
    mov x11, #1
    adds x12, x10, x11           // MAX + 1 = 0 with carry
    mrs x4, nzcv                 // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 5: SUBS 64-bit without borrow
    mov x10, #0x100000000
    mov x11, #1
    subs x12, x10, x11           // 0x100000000 - 1 = 0xFFFFFFFF, no borrow
    mrs x5, nzcv                 // Expected: N=0, Z=0, C=1, V=0 = 0x20000000

    brk #0