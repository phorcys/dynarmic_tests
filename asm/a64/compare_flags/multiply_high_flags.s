/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000020000000",
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
    // Multiply high with flags
    // ========================================

    // Test 0: SMULH (signed multiply high)
    mov x10, #0x7FFF
    lsl x10, x10, #48        // x10 = 0x7FFF000000000000 (large positive)
    mov x11, #2
    smulh x12, x10, x11      // high 64 bits of signed multiply
    subs x13, x12, #0        // check result
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: UMULH (unsigned multiply high)
    mov x10, #0xFFFF
    lsl x10, x10, #48        // x10 = 0xFFFF000000000000 (large unsigned)
    mov x11, #2
    umulh x12, x10, x11      // high 64 bits of unsigned multiply
    subs x13, x12, #0        // check result (non-zero)
    mrs x1, nzcv             // Expected: C=1 (0x20000000)

    // Test 2: SMULL (signed multiply long)
    mov w10, #1000
    mov w11, #2000
    smull x12, w10, w11      // x12 = 1000 * 2000 = 2000000
    mov x13, #1000
    mov x14, #2000
    mul x15, x13, x14
    subs x16, x12, x15
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: UMULL (unsigned multiply long)
    mov w10, #1000
    mov w11, #2000
    umull x12, w10, w11      // x12 = 1000 * 2000 = 2000000
    mov x13, #1000
    mov x14, #2000
    mul x15, x13, x14
    subs x16, x12, x15
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0
