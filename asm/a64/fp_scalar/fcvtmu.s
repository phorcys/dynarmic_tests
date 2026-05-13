/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000000"
  }
}
*/
// Test: FCVTMU - Float Convert to unsigned integer, round toward -infinity

.text
.global _start
_start:
    // Load 1.5 into S0 -> floor = 1
    movz x8, #0x0000, lsl #0
    movk x8, #0x3FC0, lsl #16
    fmov s0, w8
    fcvtmu x0, s0
    
    // Load 1.8 into S1 -> floor = 1
    movz x9, #0x6666, lsl #0
    movk x9, #0x3FE6, lsl #16
    fmov s1, w9
    fcvtmu x1, s1
    
    // Load 0.5 into S2 -> floor = 0
    movz x10, #0x0000, lsl #0
    movk x10, #0x3F00, lsl #16
    fmov s2, w10
    fcvtmu x2, s2

    brk #0
