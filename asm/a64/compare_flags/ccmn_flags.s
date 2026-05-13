/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x00000000F0000000",
    "X2": "0x0000000000000000",
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
    // Conditional comparison negative (CCMN)
    // ========================================

    // Test 0: CCMN - compare negative if condition met
    // adds x11, x10, #0: x10=10, result=10, N=0, Z=0, C=1
    // CCMN x10, #5, #0xa, ne: if NE (Z=0, true), do CMN x10, #5
    // CMN x10, #5 = compare x10 with -5 = x10 - (-5) = x10 + 5 = 15
    // 15 is positive, non-zero, so N=0, Z=0, C=1, V=0
    mov x10, #10
    adds x11, x10, #0        // 10, flags: Z=0, C=1
    ccmn x10, #5, #0xa, ne   // condition met, compare x10+5=15
    mrs x0, nzcv             // Expected: N=0, Z=0, C=1, V=0 (0x00000000)

    // Test 1: CCMN - condition not met
    // adds: x10=10, flags: Z=0, C=1
    // CCMN x10, #5, #0xf, eq: if EQ (Z=1, false), use nzcv=0xf
    // nzcv=0xf = N=1, Z=1, C=1, V=1
    mov x10, #10
    adds x11, x10, #0        // 10, flags: Z=0, C=1
    ccmn x10, #5, #0xf, eq   // condition not met, use nzcv=0xf
    mrs x1, nzcv             // Expected: N=1, Z=1, C=1, V=1 (0xF0000000)

    // Test 2: CCMN with register
    // adds: x10=100, flags: Z=0, C=1
    // CCMN x10, x11, #0x0, mi: if MI (N=1, false), use nzcv=0x0
    mov x10, #100
    mov x11, #50
    adds x12, x10, #0        // flags: N=0, Z=0
    ccmn x10, x11, #0x0, mi  // condition not met (N=0), use nzcv=0x0
    mrs x2, nzcv             // Expected: all zeros (0x00000000)

    // Test 3: CCMN chain
    // cmp x10, #10: 5 - 10 = -5, N=1, C=0 (borrow), Z=0
    // For signed: V=0, so N != V, meaning LT
    // CCMN x10, #3, #0x0, ge: if GE (N==V, false since N=1, V=0), use nzcv=0x0
    mov x10, #5
    cmp x10, #10             // 5 < 10
    ccmn x10, #3, #0x0, ge   // condition not met, use nzcv=0x0
    mrs x3, nzcv             // Expected: all zeros (0x00000000)

    brk #0
