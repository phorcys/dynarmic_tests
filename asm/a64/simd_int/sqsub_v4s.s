/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x8000000080000000"
  }
}
*/
// Test: SQSUB - Saturating Subtract (signed, 4S)

.text
.global _start
_start:
    // V0 = {0x80000000, 0x80000000} (min int32)
    movz x8, #0x0000
    movk x8, #0x8000, lsl #16
    movk x8, #0x0000, lsl #32
    movk x8, #0x8000, lsl #48
    fmov d0, x8
    
    // V1 = {0x00000001, 0x00000001}
    movz x9, #0x0001
    fmov d1, x9
    
    // SQSUB: 0x80000000 - 1 = saturates to 0x80000000 (min int32)
    sqsub v0.4s, v0.4s, v1.4s
    
    fmov x0, d0

    brk #0
