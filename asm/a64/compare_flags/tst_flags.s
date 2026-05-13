/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000",
    "X1": "0x0000000000000000",
    "X2": "0x0000000080000000",
    "X3": "0x0000000040000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // TST instruction tests (alias for ANDS with XZR)
    // ========================================

    // Test 0: TST with zero result
    mov x10, xzr
    tst x10, #0xFF               // 0 & 0xFF = 0, Z=1
    mrs x0, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 1: TST with non-zero result
    mov x10, #0xFF
    tst x10, #0x0F               // 0xFF & 0x0F = 0x0F, Z=0
    mrs x1, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 2: TST with negative result
    mov x10, #1
    lsl x10, x10, #63            // Sign bit set
    tst x10, x10                 // AND with itself, N=1
    mrs x2, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 3: TST with register
    mov w10, #0x5678
    movk w10, #0x1234, lsl #16   // w10 = 0x12345678
    mov x11, #1
    lsl x11, x11, #31            // x11 = 0x80000000
    tst x10, x11                 // 0x12345678 & 0x80000000 = 0, Z=1
    mrs x3, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 4: TST with shifted register
    mov x10, #0xF000
    mov x11, #0xF
    tst x10, x11, lsl #12        // 0xF000 & (0xF << 12) = 0xF000 & 0xF000 = 0xF000, Z=0
    mrs x4, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 5: TST with another bitmask immediate
    mov x10, #1
    lsl x10, x10, #8             // x10 = 0x100
    tst x10, #0x100              // 0x100 & 0x100 = 0x100, Z=0
    mrs x5, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    brk #0
