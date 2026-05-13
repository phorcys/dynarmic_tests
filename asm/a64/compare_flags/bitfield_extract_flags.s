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
    // Bitfield extract with flags
    // ========================================

    // Test 0: UBFX (unsigned bitfield extract)
    mov x10, #0xFF
    lsl x10, x10, #8         // x10 = 0xFF00
    ubfx x11, x10, #8, #8    // extract bits [15:8] = 0xFF
    subs x12, x11, #0xFF
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: SBFX (signed bitfield extract) - positive
    mov x10, #0x7F
    lsl x10, x10, #8         // x10 = 0x7F00
    sbfx x11, x10, #8, #8    // extract and sign extend
    subs x12, x11, #0x7F
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: SBFX (signed bitfield extract) - negative
    mov x10, #0x80
    lsl x10, x10, #8         // x10 = 0x8000, sign bit set at bit 15
    sbfx x11, x10, #8, #8    // extract bits [15:8] and sign extend
    subs x12, x11, #0
    mrs x2, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 3: BFXIL (bitfield extract and insert low)
    mov x10, #0
    mov x11, #0xFFFF
    bfxil x10, x11, #0, #16  // insert bits [15:0] of x11 into x10
    mov x12, #0xFFFF
    subs x13, x10, x12
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0
