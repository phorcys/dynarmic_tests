/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0004FFF8FFF8FFF8"
  }
}
*/
// Test: SSRA - Signed Shift Right and Accumulate (vector, 4H)

.text
.global _start
_start:
    // V0 = {-4, -4, -4, 0} = {0xFFFC, 0xFFFC, 0xFFFC, 0x0000}
    movz x8, #0xFFFC
    movk x8, #0xFFFC, lsl #16
    movk x8, #0xFFFC, lsl #32
    movk x8, #0x0000, lsl #48
    fmov d0, x8
    
    // V1 = {-16, -16, -16, 16}
    movz x9, #0xFFF0
    movk x9, #0xFFF0, lsl #16
    movk x9, #0xFFF0, lsl #32
    movk x9, #0x0010, lsl #48
    fmov d1, x9
    
    // SSRA: V0 += V1 >> 2 (signed)
    ssra v0.4h, v1.4h, #2
    
    fmov x0, d0

    brk #0
