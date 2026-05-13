/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000002"
  }
}
*/
// Test: FCVTNU - Float Convert to unsigned integer, round to nearest (ties to even)

.text
.global _start
_start:
    // Load 1.5 into S0 -> round to 2 (ties to even)
    movz x8, #0x0000, lsl #0
    movk x8, #0x3FC0, lsl #16
    fmov s0, w8
    fcvtnu x0, s0
    
    // Load 1.4 into S1 -> round to 1
    movz x9, #0x3333, lsl #0
    movk x9, #0x3FB3, lsl #16
    fmov s1, w9
    fcvtnu x1, s1
    
    // Load 1.8 into S2 -> round to 2
    movz x10, #0x6666, lsl #0
    movk x10, #0x3FE6, lsl #16
    fmov s2, w10
    fcvtnu x2, s2

    brk #0
