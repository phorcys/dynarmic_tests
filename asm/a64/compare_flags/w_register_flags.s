/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000070000000",
    "X3": "0x0000000080000000",
    "X4": "0x0000000060000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // 32-bit operations with flags (W registers)
    // In 32-bit mode, N is based on bit 31, not bit 63
    // ========================================

    // Test 0: ADDS W with negative result (bit 31 set)
    mov w10, #1
    lsl w10, w10, #31            // bit 31 set in W register
    adds w11, w10, #0            // just read flags, N=1
    mrs x0, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 1: SUBS W with zero result (C=1 means no borrow)
    mov w10, #5
    mov w11, #5
    subs w12, w10, w11           // 5 - 5 = 0, Z=1, C=1 (no borrow)
    mrs x1, nzcv                 // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    // Test 2: ADDS W with carry, zero result, and overflow
    mov w10, #1
    lsl w10, w10, #31            // 0x80000000 (min negative)
    mov w11, #1
    lsl w11, w11, #31            // 0x80000000
    adds w12, w10, w11           // 0x80000000 + 0x80000000 = 0 with overflow, Z=1, C=1, V=1
    mrs x2, nzcv                 // Expected: N=0, Z=1, C=1, V=1 = 0x70000000

    // Test 3: SUBS W with borrow (result negative)
    mov w10, #0
    subs w11, w10, #1            // 0 - 1 = 0xFFFFFFFF, N=1, C=0 (borrow)
    mrs x3, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 4: SUBS W same values = zero, no borrow
    mov w10, #1
    lsl w10, w10, #31            // 0x80000000
    mov w11, #1
    lsl w11, w11, #31            // 0x80000000
    subs w12, w10, w11           // 0x80000000 - 0x80000000 = 0, Z=1, C=1 (no borrow)
    mrs x4, nzcv                 // Expected: N=0, Z=1, C=1, V=0 = 0x60000000

    brk #0