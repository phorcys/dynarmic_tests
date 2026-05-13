/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000000",
    "X2": "0x0000000070000000",
    "X3": "0x0000000040000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // CMN (Compare Negative) - alias for ADDS with XZR
    // CMN Xn, Xm compares Xn with -Xm
    // ========================================

    // Test 0: CMN with positive values
    mov x10, #42
    cmn x10, #42            // 42 + 42 = 84
    mrs x0, nzcv            // Expected: no flags (positive, non-zero)

    // Test 1: CMN with zero operand
    mov x10, #5
    mov x11, #0
    cmn x10, x11            // 5 + 0 = 5
    mrs x1, nzcv            // Expected: no flags

    // Test 2: CMN with overflow
    mov x10, #1
    lsl x10, x10, #63       // x10 = INT64_MIN
    mov x11, #1
    lsl x11, x11, #63       // x11 = INT64_MIN
    cmn x10, x11            // INT64_MIN + INT64_MIN = 0 with overflow
    mrs x2, nzcv            // Expected: N=1, V=1, C=1

    // Test 3: CMN result zero
    mov x10, #0
    mov x11, #0
    cmn x10, x11            // 0 + 0 = 0
    mrs x3, nzcv            // Expected: Z=1

    brk #0