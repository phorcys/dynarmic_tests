/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x40000000",
    "X1": "0x00000000",
    "X2": "0x80000000",
    "X3": "0x00000000",
    "X4": "0x40000000",
    "X5": "0x40000000",
    "X6": "0x80000000",
    "X7": "0x00000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // ANDS (immediate) - Bitwise AND with immediate, setting flags
    // 
    // N = result < 0 (bit 63 or 31 set)
    // Z = result == 0
    // C = 0 (always for logical ops)
    // V = 0 (always for logical ops)
    // ========================================

    // Test 0: ANDS with result zero
    // 0 & 0xFF = 0, but Z=1 only if result is exactly 0
    // Wait, QEMU shows 0x40000000 for 0 & 0xFF?
    // Actually looking at the flags: 0x40000000 = Z=1, that's correct!
    // Z flag is bit 30, so 0x40000000 means Z=1
    mov x10, #0
    ands x12, x10, #0xFF         // 0 & 0xFF = 0
    mrs x0, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 1: ANDS with positive result
    mov x10, #0xFFFF
    ands x12, x10, #0xFF         // 0xFFFF & 0xFF = 0xFF (non-zero, positive)
    mrs x1, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 2: ANDS with negative result (bit 63)
    mov x10, #1
    lsl x10, x10, #63            // bit 63 set
    ands x12, x10, x10           // keep bit 63
    mrs x2, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 3: ANDS with bit 30 in mask
    mov x10, #0x40000000
    ands x12, x10, #0x40000000   // keep bit 30, result is 0x40000000 (positive)
    mrs x3, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 4: ANDS with zero result again
    mov x10, #0
    ands x12, x10, #0xFF         // 0 & 0xFF = 0
    mrs x4, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 5: ANDS 32-bit with result zero
    mov w10, #0
    ands w12, w10, #0xFF         // 0 & 0xFF = 0
    mrs x5, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 6: ANDS 32-bit with negative result (bit 31)
    mov w10, #0x80000000
    ands w12, w10, #0x80000000   // keep bit 31
    mrs x6, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 7: ANDS 32-bit with positive result
    mov w10, #0xFFFF
    ands w12, w10, #0xFF         // 0xFFFF & 0xFF = 0xFF
    mrs x7, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    brk #0
