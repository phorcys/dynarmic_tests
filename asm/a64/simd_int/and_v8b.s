/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000F00F0000F00F0"
  }
}
*/
// Test: AND - Vector Bitwise AND (8B - 8x 8-bit)

.text
.global _start
_start:
    // V0 = 0xFF
    movz x8, #0x00FF
    movk x8, #0x00FF, lsl #16
    movk x8, #0x00FF, lsl #32
    movk x8, #0x00FF, lsl #48
    fmov d0, x8
    
    // V1 = 0xF0, 0x0F, 0xF0, 0x0F
    movz x9, #0x00F0
    movk x9, #0x000F, lsl #16
    movk x9, #0x00F0, lsl #32
    movk x9, #0x000F, lsl #48
    fmov d1, x9
    
    and v0.8b, v0.8b, v1.8b
    
    fmov x0, d0

    brk #0
