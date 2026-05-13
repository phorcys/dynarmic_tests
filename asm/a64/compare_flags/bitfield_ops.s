/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000080000000"
  }
}
*/
.text
.global _start
_start:
    // Test bitfield operations followed by flags checking

    // Test 1: BFXIL (bitfield extract and insert low)
    mov w11, #0x5678
    movk w11, #0x1234, lsl #16  // w11 = 0x12345678
    mov w12, #0
    bfxil w12, w11, #4, #8     // Extract bits [11:4] from w11, insert into w12[7:0]
    adds w13, w12, #0          // Check flags
    mrs x0, nzcv
    // Extract bits 4-11 (8 bits) from 0x12345678 = 0x67
    // w12 = 0x67, flags: N=0, Z=0, C=0, V=0 -> 0x00000000

    // Test 2: SBFX (signed bitfield extract)
    mov w11, #0x80000000
    sbfx w12, w11, #31, #1     // Extract sign bit, sign extend
    adds w13, w12, #0          // w12 = -1 (sign extended)
    mrs x1, nzcv
    // w12 = 0xFFFFFFFF (-1), flags: N=1, Z=0, C=0, V=0 -> 0x80000000

    // Test 3: UBFX (unsigned bitfield extract)
    mov w11, #0xF0000000
    ubfx w12, w11, #28, #4     // Extract top 4 bits
    adds w13, w12, #0          // w12 = 0xF
    mrs x2, nzcv
    // w12 = 0xF, flags: N=0, Z=0, C=0, V=0 -> 0x00000000

    // Test 4: BFC (bitfield clear)
    mov w11, #0xFFFFFFFF
    bfc w11, #4, #8            // Clear bits [11:4]
    adds w12, w11, #0          // Check flags
    mrs x3, nzcv
    // w11 = 0xFFFFF00F, flags: N=1, Z=0, C=0, V=0 -> 0x80000000

    brk #0