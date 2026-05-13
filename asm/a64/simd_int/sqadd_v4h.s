/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x7FFF000400030002"
  }
}
*/
// Test: SQADD - Signed Saturating Add (vector, 4H)

.text
.global _start
_start:
    // V0 = {1, 2, 3, 32767}
    movz x8, #0x0001
    movk x8, #0x0002, lsl #16
    movk x8, #0x0003, lsl #32
    movk x8, #0x7FFF, lsl #48
    fmov d0, x8
    
    // V1 = {1, 1, 1, 1}
    movz x9, #0x0001
    movk x9, #0x0001, lsl #16
    movk x9, #0x0001, lsl #32
    movk x9, #0x0001, lsl #48
    fmov d1, x9
    
    // SQADD: saturating add
    // 1+1=2, 2+1=3, 3+1=4, 32767+1=32767 (saturated)
    sqadd v0.4h, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
