/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0004000600060004"
  }
}
*/
// Test: MUL - Vector Multiply (4H - 4x 16-bit)

.text
.global _start
_start:
    // V0 = {1, 2, 3, 4}
    movz x8, #0x0001
    movk x8, #0x0002, lsl #16
    movk x8, #0x0003, lsl #32
    movk x8, #0x0004, lsl #48
    fmov d0, x8
    
    // V1 = {4, 3, 2, 1}
    movz x9, #0x0004
    movk x9, #0x0003, lsl #16
    movk x9, #0x0002, lsl #32
    movk x9, #0x0001, lsl #48
    fmov d1, x9
    
    mul v0.4h, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
