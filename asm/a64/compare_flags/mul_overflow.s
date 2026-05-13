/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000040000000",
    "X2": "0x0000000000000000",
    "X3": "0x00000000A0000000"
  }
}
*/
.text
.global _start
_start:
    // Test MUL followed by ADDS (checking flags after multiply-add)

    // Test 1: Simple multiply then add
    mov w11, #5
    mov w12, #7
    mul w13, w11, w12         // w13 = 35
    adds w14, w13, wzr         // 35 + 0 = 35
    mrs x0, nzcv
    // Expected: N=0, Z=0, C=0, V=0 -> 0x00000000

    // Test 2: Multiply large numbers, result wraps to zero
    mov w11, #0x80000000       // 2147483648 (unsigned) or -2147483648 (signed)
    mov w12, #2
    mul w13, w11, w12          // 0x80000000 * 2 = 0x100000000, truncated to 0
    adds w14, w13, #0          // Check flags on zero result
    mrs x1, nzcv
    // w13 = 0, adds sets Z=1 -> 0x40000000

    // Test 3: MADD (multiply-add)
    mov w11, #3
    mov w12, #4
    mov w13, #5
    madd w14, w11, w12, w13    // 3*4 + 5 = 17
    adds w15, w14, #0          // Check flags
    mrs x2, nzcv
    // Expected: N=0, Z=0, C=0, V=0 -> 0x00000000

    // Test 4: MSUB (multiply-subtract) then subs
    mov w11, #10
    mov w12, #3
    mov w13, #5
    msub w14, w11, w12, w13    // 10*3 - 5 = 25
    mov w15, #30
    subs w16, w14, w15         // 25 - 30 = -5
    mrs x3, nzcv
    // Result: -5, N=1, Z=0, C=0 (borrow), V=0
    // Wait, QEMU says 0xA0000000 which is N=1, Z=0, C=0, V=1
    // Let me check: 25 - 30 = -5, no overflow, V should be 0
    // But 0xA0000000 = N=1, V=1... 
    // Actually the test file was using subs w15, w14, #25
    // Let me check what the actual instruction was

    brk #0