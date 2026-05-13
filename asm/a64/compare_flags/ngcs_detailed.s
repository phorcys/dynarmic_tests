/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000060000000",
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
    // NGCS (Negate with Carry and set flags) tests
    // NGCS Xd, Xn: Xd = -Xn - 1 + C, sets flags
    // Equivalent to SBCS Xd, XZR, Xn
    // ========================================

    // Test 0: NGCS with C=1 (no borrow initially)
    msr nzcv, xzr                // clear flags
    mov x10, #5
    mov x11, #0
    cmp x11, x11                 // 0 - 0 = 0, C=1 (no borrow)
    ngcs x12, x10                // 0 - 5 - 1 + 1 = -5 (with C=1)
    mrs x0, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 1: NGCS with C=0 (borrow initially)
    msr nzcv, xzr                // clear flags
    mov x10, #5
    mov x11, #0
    mov x12, #1
    cmp x11, x12                 // 0 - 1, C=0 (borrow)
    ngcs x13, x10                // 0 - 5 - 1 + 0 = -6
    mrs x1, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 2: NGCS of zero with C=1
    msr nzcv, xzr
    mov x10, #0
    mov x11, #0
    cmp x11, x11                 // C=1
    ngcs x12, x10                // 0 - 0 - 1 + 1 = 0, Z=1, C=1
    mrs x2, nzcv                 // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 3: NGCS of max negative with overflow
    msr nzcv, xzr
    mov x10, #1
    lsl x10, x10, #63            // max negative
    mov x11, #0
    cmp x11, x11                 // C=1
    ngcs x12, x10                // overflow case
    mrs x3, nzcv                 // Expected: N=1, V=1

    brk #0