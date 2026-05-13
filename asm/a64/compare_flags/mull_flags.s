/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
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
    // UMADDL/SMADDL (unsigned/signed multiply-add long)
    // ========================================

    // Test 0: UMADDL basic
    mov w10, #100
    mov w11, #5
    mov x12, #10
    umaddl x13, w10, w11, x12   // 100*5 + 10 = 510
    subs x14, x13, #510
    mrs x0, nzcv                // Expected: Z=1, C=1

    // Test 1: SMADDL with negative
    mov w10, #-5
    mov w11, #6
    mov x12, #10
    smaddl x13, w10, w11, x12   // -5*6 + 10 = -20
    mov x14, #-20
    subs x15, x13, x14
    mrs x1, nzcv                // Expected: Z=1, C=1

    // Test 2: UMULL (alias for UMADDL with Xa=0)
    mov w10, #100
    mov w11, #5
    umull x12, w10, w11         // 100*5 = 500
    subs x13, x12, #500
    mrs x2, nzcv                // Expected: Z=1, C=1

    // Test 3: SMULL (alias for SMADDL with Xa=0)
    mov w10, #-5
    mov w11, #6
    smull x12, w10, w11         // -5*6 = -30
    mov x13, #-30
    subs x14, x12, x13
    mrs x3, nzcv                // Expected: Z=1, C=1

    brk #0
