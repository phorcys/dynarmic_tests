/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x00000000A0000000",
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
    // Rotate and extend with flags
    // ========================================

    // Test 0: ROR (rotate right) then check flags
    mov x10, #1
    lsl x10, x10, #4         // x10 = 0x10
    ror x11, x10, #4         // rotate right 4 bits: 0x10 -> 0x01
    subs x12, x11, #1
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: ROR with sign bit
    mov x10, #1
    lsl x10, x10, #63        // x10 = 0x8000000000000000
    ror x11, x10, #1         // rotate: bit 0 goes to bit 63
    // 0x8000000000000000 >> 1 with bit 0 going to bit 63
    // Result: 0x4000000000000000 with bit 63 set from original bit 0 (which was 0)
    // Wait, ROR rotates: bit 0 -> bit 63, bit 63 -> bit 62, etc.
    // 0x8000000000000000 has bit 63=1, bit 0=0
    // After ROR 1: bit 63 gets bit 0 (0), bit 62 gets bit 63 (1)
    // Result: 0x4000000000000000
    subs x12, x11, x11
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: EXTR (extract register)
    mov x10, #0xFF
    mov x11, #0xFF
    lsl x11, x11, #8         // x11 = 0xFF00
    extr x12, x10, x11, #8   // extract from pair: result = 0xFFFF
    mov x13, #0xFFFF
    subs x14, x12, x13
    mrs x2, nzcv             // Expected: N=1, Z=1, C=1 (0xA0000000)?

    // Test 3: BIC with flags
    mov x10, #0xFF
    mov x11, #0x0F
    bic x12, x10, x11        // x12 = 0xFF & ~0x0F = 0xF0
    subs x13, x12, #0xF0
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0