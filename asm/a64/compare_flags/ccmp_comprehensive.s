/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000020000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000040000000"
  }
}
*/
.text
.global _start
_start:
    // Test CCMP (Conditional Compare) comprehensively
    // CCMP Xn, Xm, #nzcv, cond
    // If condition true: flags from Xn - Xm
    // If condition false: flags set to #nzcv

    // Test 1: Condition false - use fallback flags
    mov x11, #5
    mov x12, #3
    mov x10, #0x00000000        // All flags clear (Z=0)
    msr nzcv, x10
    ccmp x11, x12, #0, eq       // If EQ (Z=1) false, so use #0
    mrs x0, nzcv
    // Expected: 0x00000000

    // Test 2: Condition true - compare 5 and 3
    mov x10, #0x40000000        // Z=1
    msr nzcv, x10
    ccmp x11, x12, #0, eq       // If EQ (Z=1) true, compare 5 - 3 = 2
    mrs x1, nzcv
    // 5 - 3 = 2, flags: N=0, Z=0, C=1, V=0 -> 0x20000000

    // Test 3: CCMN (Conditional Compare Negative)
    mov x10, #0x00000000        // Z=0
    msr nzcv, x10
    mov x11, #5
    mov x12, #3
    ccmn x11, x12, #0, ne       // If NE (Z=0) true, compare 5 + 3 = 8
    mrs x2, nzcv
    // 5 + 3 = 8, flags: N=0, Z=0, C=0, V=0 -> 0x00000000

    // Test 4: CCMP with condition false, set Z flag in fallback
    mov x10, #0x00000000        // Z=0
    msr nzcv, x10
    ccmp x11, x12, #4, eq       // If EQ (Z=1) false, flags = #4
    // #4 = nzcv with Z=1 (bit 2 in nzcv nibble)
    // NZCV format: bit 30 = Z, so #4 means Z=1 -> 0x40000000
    mrs x3, nzcv
    // Expected: 0x40000000

    brk #0