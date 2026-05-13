/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00FF00FF00FF00FF"
  }
}
*/
// Test: ORR - Vector Bitwise OR (8B - 8x 8-bit)

.text
.global _start
_start:
    // V0 = 0xF0
    movz x8, #0x00F0
    movk x8, #0x00F0, lsl #16
    movk x8, #0x00F0, lsl #32
    movk x8, #0x00F0, lsl #48
    fmov d0, x8
    
    // V1 = 0x0F
    movz x9, #0x000F
    movk x9, #0x000F, lsl #16
    movk x9, #0x000F, lsl #32
    movk x9, #0x000F, lsl #48
    fmov d1, x9
    
    orr v0.8b, v0.8b, v1.8b
    
    fmov x0, d0

    brk #0
