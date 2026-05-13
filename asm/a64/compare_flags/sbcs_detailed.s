/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000080000000",
    "X3": "0x0000000030000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // SBCS (Subtract with Carry and Set flags)
    // SBCS Xd, Xn, Xm = Xd = Xn - Xm - !C
    // ========================================

    // Test 0: SBCS with C=1 (no borrow)
    mov x10, #10
    mov x11, #3
    cmp x10, x10            // C=1
    sbcs x12, x10, x11      // 10 - 3 - 0 = 7
    subs x13, x12, #7
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: SBCS with C=0 (borrow)
    mov x10, #10
    mov x11, #3
    mov x14, #0
    subs x15, x14, #1       // C=0 (borrow)
    sbcs x12, x10, x11      // 10 - 3 - 1 = 6
    subs x13, x12, #6
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: SBCS resulting in borrow
    mov x10, #3
    mov x11, #10
    cmp x10, x10            // C=1
    sbcs x12, x10, x11      // 3 - 10 - 0 = -7 (borrow)
    mrs x2, nzcv            // Expected: N=1

    // Test 3: SBCS 32-bit with overflow
    movz w10, #0x0000
    movk w10, #0x8000, lsl #16  // w10 = INT32_MIN
    mov w11, #1
    cmp w10, w10            // C=1
    sbcs w12, w10, w11      // INT32_MIN - 1 = 0x7FFFFFFF (positive max)
    mrs x3, nzcv            // Expected: N=1, V=1

    brk #0
