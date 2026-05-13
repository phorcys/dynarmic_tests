/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0002000200010001"
  }
}
*/
// Test: SRHADD - Signed Rounding Halving Add (4H)

.text
.global _start
_start:
    // V0 = {1, 2, 3, 4}
    movz x8, #0x0001
    movk x8, #0x0002, lsl #16
    movk x8, #0x0003, lsl #32
    movk x8, #0x0004, lsl #48
    fmov d0, x8
    
    // V1 = {0, 0, 0, 0}
    fmov d1, xzr
    
    // SRHADD: (V0 + V1 + 1) >> 1 = {(1+0+1)/2, (2+0+1)/2, (3+0+1)/2, (4+0+1)/2} = {1, 1, 2, 2}
    srhadd v0.4h, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
