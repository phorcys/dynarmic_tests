/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x00000000A0000000",
    "X2": "0x0000000020000000",
    "X3": "0x0000000080000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000080000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Negative flag tests (N flag)
    // ========================================

    // Test 0: ADDS result is positive
    mov x10, #10
    mov x11, #20
    adds x12, x10, x11           // 10 + 20 = 30 (positive)
    mrs x0, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 1: ADDS result is negative with overflow
    mov x10, #-10
    mov x11, #-20
    adds x12, x10, x11           // -10 + (-20) = -30 (negative, overflow, C=1)
    mrs x1, nzcv                 // Expected: N=1, Z=0, C=1, V=0 = 0xA0000000

    // Test 2: SUBS result is positive
    mov x10, #30
    mov x11, #10
    subs x12, x10, x11           // 30 - 10 = 20 (positive)
    mrs x2, nzcv                 // Expected: N=0, Z=0, C=1, V=0 = 0x20000000

    // Test 3: SUBS result is negative
    mov x10, #10
    mov x11, #30
    subs x12, x10, x11           // 10 - 30 = -20 (negative)
    mrs x3, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 4: ANDS result is positive
    mov x10, #0x7FFFFFFF
    mov x11, #0x7FFFFFFF
    ands x12, x10, x11           // Positive result
    mrs x4, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 5: ANDS result is negative
    mov x10, #1
    lsl x10, x10, #63            // 0x8000000000000000
    ands x12, x10, x10           // Negative result
    mrs x5, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    brk #0