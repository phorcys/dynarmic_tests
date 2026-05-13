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
    // Bitwise insert (BFI/BFXIL)
    // ========================================

    // Test 0: BFI basic
    mov x10, #0xFF
    mov x11, #0
    bfi x11, x10, #8, #8    // insert 8 bits at position 8
    // x11 = (0 & ~(0xFF << 8)) | (0xFF << 8) = 0xFF00
    mov x12, #0xFF
    lsl x12, x12, #8        // x12 = 0xFF00
    subs x13, x11, x12
    mrs x0, nzcv            // Expected: Z=1, C=1

    // Test 1: BFXIL (bitfield extract and insert low)
    mov x10, #0xFF00
    mov x11, #0
    bfxil x11, x10, #8, #8  // extract 8 bits from position 8, insert at position 0
    // x11 = 0xFF
    subs x12, x11, #0xFF
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: BFI with sign extension check
    mov x10, #0x80          // MSB set
    mov x11, #0
    bfi x11, x10, #0, #8    // insert at position 0
    // x11 = 0x80 (positive in 64-bit)
    subs x12, x11, #0x80
    mrs x2, nzcv            // Expected: Z=1, C=1

    // Test 3: BFI 32-bit
    mov w10, #0xFFFF
    mov w11, #0
    bfi w11, w10, #16, #16  // insert 16 bits at position 16
    mov w12, #0xFFFF
    lsl w12, w12, #16       // w12 = 0xFFFF0000
    subs w13, w11, w12
    mrs x3, nzcv            // Expected: N=1

    brk #0
