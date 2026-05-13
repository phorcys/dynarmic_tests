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
    // UBFM/SBFM (Unsigned/Signed Bitfield Move) tests
    // UBFM: unsigned bitfield move (zero-extend)
    // SBFM: signed bitfield move (sign-extend)
    // ========================================

    // Test 0: UBFM basic (UBFIZ alias)
    mov x10, #0xFF
    ubfm x11, x10, #0, #7    // extract bits 0-7, zero-extend
    // x11 = 0xFF
    subs x12, x11, #0xFF
    mrs x0, nzcv             // Expected: Z=1, C=1

    // Test 1: SBFM with sign extension (SBFX alias)
    mov x10, #0x80           // x10 = 0x80 (negative in 8-bit)
    sbfm x11, x10, #0, #7    // extract bits 0-7, sign-extend
    // x11 = 0xFFFFFFFFFFFFFF80 (sign-extended)
    mov x12, #-128
    subs x13, x11, x12
    mrs x1, nzcv             // Expected: Z=1, C=1

    // Test 2: UBFM extracting high bits
    mov x10, #0xFF
    lsl x10, x10, #8         // x10 = 0xFF00
    ubfm x11, x10, #8, #15   // extract bits 8-15
    // x11 = 0xFF
    subs x12, x11, #0xFF
    mrs x2, nzcv             // Expected: Z=1, C=1

    // Test 3: SBFM with positive value
    mov x10, #0x7F           // x10 = 0x7F (positive in 8-bit)
    sbfm x11, x10, #0, #7    // extract bits 0-7, sign-extend
    // x11 = 0x7F (positive, no sign extension)
    subs x12, x11, #0x7F
    mrs x3, nzcv             // Expected: Z=1, C=1

    brk #0
