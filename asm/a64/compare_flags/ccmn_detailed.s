/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000060000000",
    "X2": "0x00000000F0000000",
    "X3": "0x0000000000000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // CCMN (Conditional Compare Negative) tests
    // CCMN Xn, Xm, #nzcv, cond
    // If condition true: set flags from (Xn + Xm)
    // If condition false: set flags to immediate nzcv
    // ========================================

    // Test 0: CCMN when condition true (EQ), result non-zero
    mov x10, #5
    mov x11, #3
    cmp x10, #5                  // sets Z=1 (EQ true)
    ccmn x10, x11, #0, eq        // 5 + 3 = 8, non-zero, N=0, Z=0
    mrs x0, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 1: CCMN when condition true (EQ), result zero
    mov x10, #5
    mov x11, #5
    neg x11, x11                 // x11 = -5
    cmp x10, #5                  // sets Z=1 (EQ true)
    ccmn x10, x11, #0, eq        // 5 + (-5) = 0, Z=1, C=1
    mrs x1, nzcv                 // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 2: CCMN when condition false (NE), uses immediate nzcv
    mov x10, #5
    mov x11, #100
    cmp x10, #5                  // sets Z=1 (EQ true), so NE is false
    ccmn x10, x11, #0xF, ne      // condition false, use nzcv=0xF = N=1,Z=1,C=1,V=1
    mrs x2, nzcv                 // Expected: all flags set = 0xF0000000

    // Test 3: CCMN with immediate
    // CCMN Xn, #imm, #nzcv, cond
    mov x10, #10
    cmp x10, #10                 // EQ true
    ccmn x10, #5, #0, eq         // 10 + 5 = 15, non-zero
    mrs x3, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    brk #0