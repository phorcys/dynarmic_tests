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
    // MADD/MSUB (Multiply-add/subtract) flags tests
    // These do NOT set flags, but we verify results with SUBS
    // ========================================

    // Test 0: MADD basic
    mov x10, #5
    mov x11, #6
    mov x12, #10
    madd x13, x10, x11, x12   // 5*6 + 10 = 40
    subs x14, x13, #40
    mrs x0, nzcv              // Expected: Z=1, C=1

    // Test 1: MSUB basic
    mov x10, #5
    mov x11, #6
    mov x12, #10
    msub x13, x10, x11, x12   // 10 - 5*6 = -20
    mov x14, #-20
    subs x15, x13, x14        // verify
    mrs x1, nzcv              // Expected: Z=1, C=1

    // Test 2: MADD with negative
    mov x10, #-5
    mov x11, #6
    mov x12, #10
    madd x13, x10, x11, x12   // -5*6 + 10 = -20
    mov x14, #-20
    subs x15, x13, x14        // verify
    mrs x2, nzcv              // Expected: Z=1, C=1

    // Test 3: SMADDL (signed multiply-add long)
    mov w10, #5
    mov w11, #6
    mov x12, #10
    smaddl x13, w10, w11, x12   // 5*6 + 10 = 40
    subs x14, x13, #40
    mrs x3, nzcv                // Expected: Z=1, C=1

    brk #0
