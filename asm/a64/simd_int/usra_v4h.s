/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0008000800080008"
  }
}
*/
// Test: USRA - Unsigned Shift Right and Accumulate (vector, 4H)

.text
.global _start
_start:
    // V0 = {4, 4, 4, 4} (accumulator)
    movz x8, #0x0004
    movk x8, #0x0004, lsl #16
    movk x8, #0x0004, lsl #32
    movk x8, #0x0004, lsl #48
    fmov d0, x8
    
    // V1 = {16, 16, 16, 16}
    movz x9, #0x0010
    movk x9, #0x0010, lsl #16
    movk x9, #0x0010, lsl #32
    movk x9, #0x0010, lsl #48
    fmov d1, x9
    
    // USRA: V0 += V1 >> 2 = 4 + 16/4 = 4 + 4 = 8
    usra v0.4h, v1.4h, #2
    
    fmov x0, d0

    brk #0
