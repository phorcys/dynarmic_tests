/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000",
    "X1": "0x0000000000000000",
    "X2": "0x0000000040000000",
    "X3": "0x0000000080000000",
    "X4": "0x0000000000000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // ANDS with immediate values tests
    // ANDS sets N, Z, C=0, V preserved
    // ========================================

    // Test 0: ANDS with zero result
    mov x10, #0
    ands x11, x10, #0xFF         // 0 & 0xFF = 0, Z=1
    mrs x0, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 1: ANDS with positive result
    mov x10, #0xFF
    ands x11, x10, #0xF0         // 0xFF & 0xF0 = 0xF0, Z=0, N=0
    mrs x1, nzcv                 // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 2: ANDS with zero using bitmask
    mov x10, #0xFF
    ands x11, x10, #0x100        // 0xFF & 0x100 = 0, Z=1
    mrs x2, nzcv                 // Expected: N=0, Z=1, C=0, V=0 = 0x40000000

    // Test 3: ANDS with negative result (sign bit set in result)
    mov x10, #1
    lsl x10, x10, #63            // sign bit
    ands x11, x10, x10           // sign_bit & sign_bit = sign_bit, N=1
    mrs x3, nzcv                 // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    // Test 4: ANDS bit 31 (not negative in 64-bit mode)
    mov x10, #1
    lsl x10, x10, #31            // bit 31 set
    ands x11, x10, x10           // bit 31 stays, but not bit 63
    mrs x4, nzcv                 // Expected: N=0 (bit 63 is 0), Z=0

    brk #0