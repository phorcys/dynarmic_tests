/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x00000000A0000000",
    "X2": "0x0000000060000000",
    "X3": "0x0000000060000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Multiply-accumulate with flags
    // ========================================

    // Test 0: MADD (multiply-add)
    mov x10, #10
    mov x11, #20
    mov x12, #5
    madd x13, x10, x11, x12  // x13 = 10*20 + 5 = 205
    subs x14, x13, #205
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: MSUB (multiply-subtract)
    mov x10, #10
    mov x11, #20
    mov x12, #50
    msub x13, x10, x11, x12  // x13 = 50 - 10*20 = -150
    subs x14, x13, #0
    mrs x1, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 2: SMADDL (signed multiply-add long)
    mov w10, #100
    mov w11, #200
    mov x12, #100
    smaddl x13, w10, w11, x12  // x13 = 100*200 + 100 = 20100
    mov x14, #20100
    subs x15, x13, x14
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: SMSUBL (signed multiply-subtract long)
    mov w10, #100
    mov w11, #200
    mov x12, #50000
    smsubl x13, w10, w11, x12  // x13 = 50000 - 100*200 = 30000
    mov x14, #30000
    subs x15, x13, x14
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0
