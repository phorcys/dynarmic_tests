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
    // MSUB (multiply-subtract) detailed tests
    // ========================================

    // Test 0: MSUB basic
    mov x10, #5
    mov x11, #6
    mov x12, #100
    msub x13, x10, x11, x12   // 100 - 5*6 = 70
    subs x14, x13, #70
    mrs x0, nzcv              // Expected: Z=1, C=1

    // Test 1: MSUB with result = 0
    mov x10, #5
    mov x11, #6
    mov x12, #30
    msub x13, x10, x11, x12   // 30 - 5*6 = 0
    subs x14, x13, #0
    mrs x1, nzcv              // Expected: Z=1, C=1

    // Test 2: MSUB with negative result
    mov x10, #5
    mov x11, #6
    mov x12, #20
    msub x13, x10, x11, x12   // 20 - 5*6 = -10
    mov x14, #-10
    subs x15, x13, x14
    mrs x2, nzcv              // Expected: Z=1, C=1

    // Test 3: MNEG (alias for MSUB with Xa=0)
    mov x10, #5
    mov x11, #6
    mneg x12, x10, x11        // 0 - 5*6 = -30
    mov x13, #-30
    subs x14, x12, x13
    mrs x3, nzcv              // Expected: Z=1, C=1

    brk #0
