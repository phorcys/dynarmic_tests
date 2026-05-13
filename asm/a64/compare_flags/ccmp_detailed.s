/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000020000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000060000000",
    "X3": "0x00000000A0000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // CCMP (Conditional Compare) detailed tests
    // CCMP Xn, Xm, #nzcv, cond
    // If condition true: set flags from (Xn - Xm)
    // If condition false: set flags to immediate nzcv
    // ========================================

    // Test 0: CCMP when condition true (EQ), result non-zero positive
    mov x10, #10
    mov x11, #3
    cmp x10, #10                 // sets Z=1 (EQ true)
    ccmp x10, x11, #0, eq        // 10 - 3 = 7, non-zero positive, C=1 (no borrow)
    mrs x0, nzcv                 // Expected: N=0, Z=0, C=1, V=0 = 0x20000000

    // Test 1: CCMP when condition true (EQ), result negative
    mov x10, #3
    mov x11, #10
    cmp x10, #3                  // sets Z=1 (EQ true)
    ccmp x10, x11, #0, eq        // 3 - 10 = -7, negative, C=0 (borrow)
    mrs x1, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 2: CCMP when condition true (EQ), result zero
    mov x10, #5
    mov x11, #5
    cmp x10, #5                  // sets Z=1 (EQ true)
    ccmp x10, x11, #0, eq        // 5 - 5 = 0, Z=1, C=1 (no borrow)
    mrs x2, nzcv                 // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 3: CCMP when condition false (NE), uses immediate nzcv
    mov x10, #5
    mov x11, #100
    cmp x10, #5                  // sets Z=1 (EQ true), so NE is false
    ccmp x10, x11, #0xA, ne      // condition false, use nzcv=0xA = N=1,Z=0,C=1,V=1
    mrs x3, nzcv                 // Expected: N=1, Z=0, C=1, V=1 = 0xA0000000

    brk #0