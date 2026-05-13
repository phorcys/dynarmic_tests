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
    // MUL with flags verification
    // MUL doesn't set flags, but we can verify results with ADDS/SUBS
    // ========================================

    // Test 0: MUL positive * positive
    mov x10, #10
    mov x11, #20
    mul x12, x10, x11            // 10 * 20 = 200
    subs x13, x12, #200          // verify
    mrs x0, nzcv                 // Expected: Z=1, C=1 = 0x60000000

    // Test 1: MUL negative * positive
    mov x10, #10
    neg x10, x10                 // -10
    mov x11, #20
    mul x12, x10, x11            // -10 * 20 = -200
    mov x13, #200
    neg x13, x13                 // -200
    subs x14, x12, x13           // verify -200 == -200
    mrs x1, nzcv                 // Expected: Z=1, C=1 = 0x60000000

    // Test 2: MNEG (negate result)
    mov x10, #10
    mov x11, #20
    mneg x12, x10, x11           // -(10 * 20) = -200
    mov x13, #200
    neg x13, x13                 // -200
    subs x14, x12, x13           // verify
    mrs x2, nzcv                 // Expected: Z=1, C=1 = 0x60000000

    // Test 3: SMULL (signed multiply long)
    mov w10, #100
    mov w11, #200
    smull x12, w10, w11          // 100 * 200 = 20000
    mov x13, #20000
    subs x14, x12, x13           // verify
    mrs x3, nzcv                 // Expected: Z=1, C=1 = 0x60000000

    brk #0