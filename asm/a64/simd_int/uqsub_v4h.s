/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000200010000"
  }
}
*/
// Test: UQSUB - Unsigned Saturating Subtract (vector, 4H)

.text
.global _start
_start:
    // V0 = {1, 2, 3, 0}
    movz x8, #0x0001
    movk x8, #0x0002, lsl #16
    movk x8, #0x0003, lsl #32
    movk x8, #0x0000, lsl #48
    fmov d0, x8
    
    // V1 = {1, 1, 1, 1}
    movz x9, #0x0001
    movk x9, #0x0001, lsl #16
    movk x9, #0x0001, lsl #32
    movk x9, #0x0001, lsl #48
    fmov d1, x9
    
    // UQSUB: unsigned saturating subtract
    // 1-1=0, 2-1=1, 3-1=2, 0-1=0 (saturated)
    uqsub v0.4h, v0.4h, v1.4h
    
    fmov x0, d0

    brk #0
