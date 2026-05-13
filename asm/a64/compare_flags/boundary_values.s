/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000090000000",
    "X3": "0x0000000060000000",
    "X4": "0x0000000000000000"
  }
}
*/
.text
.global _start
_start:
    // Test boundary values and their effect on flags

    // Test 1: 0 - 1 = -1 (borrow, N=1)
    mov w11, #0
    mov w12, #1
    subs w13, w11, w12       // 0 - 1 = -1, flags: N=1, Z=0, C=0, V=0
    mrs x0, nzcv
    // Expected: N=1, Z=0, C=0, V=0 -> 0x80000000

    // Test 2: INT_MIN + 1 (no overflow)
    mov w11, #0x80000000    // INT_MIN
    mov w12, #1
    adds w13, w11, w12       // INT_MIN + 1 = 0x80000001, flags: N=1, Z=0, C=0, V=0
    mrs x1, nzcv
    // Expected: N=1, Z=0, C=0, V=0 -> 0x80000000

    // Test 3: INT_MAX + 1 (signed overflow)
    mov w11, #0x7FFFFFFF    // INT_MAX
    mov w12, #1
    adds w13, w11, w12       // INT_MAX + 1 = 0x80000000, flags: N=1, Z=0, C=0, V=1
    mrs x2, nzcv
    // Expected: N=1, Z=0, C=0, V=1 -> 0x90000000

    // Test 4: MAX_UINT + 1 (unsigned carry)
    mov w11, #0xFFFFFFFF
    mov w12, #1
    adds w13, w11, w12       // MAX_UINT + 1 = 0, flags: N=0, Z=1, C=1, V=0
    mrs x3, nzcv
    // Expected: N=0, Z=1, C=1, V=0 -> 0x60000000

    // Test 5: 0 - MAX_UINT (borrow, result=1)
    mov w11, #0
    mov w12, #0xFFFFFFFF
    subs w13, w11, w12       // 0 - MAX_UINT = 1, flags: N=0, Z=0, C=0, V=0
    mrs x4, nzcv
    // Expected: N=0, Z=0, C=0, V=0 -> 0x00000000

    brk #0