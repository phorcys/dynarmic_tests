/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000A0000000",
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
    // SBFIZ/UBFIZ (Signed/Unsigned Bit Field Insert Zero)
    // ========================================

    // Test 0: SBFIZ - insert and sign-extend
    mov x10, #0xFF
    sbfiz x11, x10, #4, #8  // take 8 bits, insert at bit 4, sign-extend
    // bit 11 (MSB of 8 bits) = 1, so sign-extend
    // result = 0xFFFFFFFFFFFFFF00 | (0xFF << 4) = ?
    subs x12, x11, #0
    mrs x0, nzcv            // Expected: N=1

    // Test 1: UBFIZ - insert and zero-extend
    mov x10, #0xFF
    ubfiz x11, x10, #4, #8  // take 8 bits, insert at bit 4, zero-extend
    // result = 0xFF0
    mov x13, #0xFF
    lsl x13, x13, #4        // x13 = 0xFF0
    subs x12, x11, x13
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: SBFIZ with positive value
    mov x10, #0x7F          // MSB = 0
    sbfiz x11, x10, #4, #8  // sign bit = 0, positive
    mov x13, #0x7F
    lsl x13, x13, #4        // x13 = 0x7F0
    subs x12, x11, x13
    mrs x2, nzcv            // Expected: Z=1, C=1

    // Test 3: UBFIZ with full width
    movz x10, #0xFFFF
    ubfiz x11, x10, #0, #16 // take 16 bits, insert at bit 0
    movz x13, #0xFFFF
    subs x12, x11, x13
    mrs x3, nzcv            // Expected: Z=1, C=1

    brk #0
