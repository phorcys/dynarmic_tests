/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x3F8000003F800000"
  }
}
*/
// Test: FMINNM - Float Minimum Number (vector)
// {1.0, 2.0} vs {2.0, 1.0} -> {1.0, 1.0}

.text
.global _start
_start:
    // V0 = {1.0, 2.0}
    movz x8, #0x0000
    movk x8, #0x3F80, lsl #16
    movk x8, #0x0000, lsl #32
    movk x8, #0x4000, lsl #48
    fmov d0, x8
    
    // V1 = {2.0, 1.0}
    movz x9, #0x0000
    movk x9, #0x4000, lsl #16
    movk x9, #0x0000, lsl #32
    movk x9, #0x3F80, lsl #48
    fmov d1, x9
    
    fminnm v0.2s, v0.2s, v1.2s
    
    fmov x0, d0

    brk #0
