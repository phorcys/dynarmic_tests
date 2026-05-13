/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x4000000040000000"
  }
}
*/
// Test: FRINTI - Float Round to Nearest Integral (vector)
// {1.5, 2.5} -> {2.0, 2.0} (ties to even for FRINTI)

.text
.global _start
_start:
    // V0 = {1.5, 2.5} = {0x3FC00000, 0x40200000}
    movz x8, #0x0000
    movk x8, #0x3FC0, lsl #16
    movk x8, #0x0000, lsl #32
    movk x8, #0x4020, lsl #48
    fmov d0, x8
    
    frinti v0.2s, v0.2s
    
    fmov x0, d0

    brk #0
