/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Test: EOR - Vector Bitwise XOR (8B - 8x 8-bit)

.text
.global _start
_start:
    // V0 = 0xFF
    movz x8, #0x00FF
    movk x8, #0x00FF, lsl #16
    movk x8, #0x00FF, lsl #32
    movk x8, #0x00FF, lsl #48
    fmov d0, x8
    
    // V1 = 0xFF (same as V0)
    movz x9, #0x00FF
    movk x9, #0x00FF, lsl #16
    movk x9, #0x00FF, lsl #32
    movk x9, #0x00FF, lsl #48
    fmov d1, x9
    
    eor v0.8b, v0.8b, v1.8b
    
    fmov x0, d0

    brk #0
