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
    // Conditional select with comparison (CSEL variations)
    // ========================================

    // Test 0: CSEL with positive values
    mov x10, #10
    mov x11, #20
    cmp x10, x11            // 10 < 20, so LT condition
    csel x12, x10, x11, lt  // if LT, x12 = x10 = 10
    subs x13, x12, #10
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: CSEL with GT condition
    mov x10, #30
    mov x11, #20
    cmp x10, x11            // 30 > 20, so GT condition
    csel x12, x10, x11, gt  // if GT, x12 = x10 = 30
    subs x13, x12, #30
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: CSEL with EQ condition (false)
    mov x10, #10
    mov x11, #20
    cmp x10, x11            // 10 != 20, so EQ is false
    csel x12, x10, x11, eq  // if EQ (false), x12 = x11 = 20
    subs x13, x12, #20
    mrs x2, nzcv            // Expected: Z=1, C=1

    // Test 3: CSEL with NE condition (true)
    mov x10, #10
    mov x11, #20
    cmp x10, x11            // 10 != 20, so NE is true
    csel x12, x10, x11, ne  // if NE (true), x12 = x10 = 10
    subs x13, x12, #10
    mrs x3, nzcv            // Expected: Z=1, C=1

    brk #0
