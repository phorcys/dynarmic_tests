/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002",
    "X1": "0x0000000000000002",
    "X2": "0x0000000000000001"
  }
}
*/
// Test: FCVTPU - Float Convert to unsigned integer, round toward +infinity
// ceil(1.5) = 2, ceil(1.2) = 2, ceil(0.5) = 1

.text
.global _start
_start:
    // Load 1.5 into S0 -> ceil = 2
    movz x8, #0x0000, lsl #0
    movk x8, #0x3FC0, lsl #16
    fmov s0, w8
    fcvtpu x0, s0
    
    // Load 1.2 into S1 -> ceil = 2
    movz x9, #0x3333, lsl #0
    movk x9, #0x3F99, lsl #16
    fmov s1, w9
    fcvtpu x1, s1
    
    // Load 0.5 into S2 -> ceil = 1
    movz x10, #0x0000, lsl #0
    movk x10, #0x3F00, lsl #16
    fmov s2, w10
    fcvtpu x2, s2

    brk #0
