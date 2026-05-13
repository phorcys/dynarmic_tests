/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// Test: FCMP - Floating-point Compare

.text
.global _start
_start:
    // Load 1.0 into S0
    movz w8, #0x0000
    movk w8, #0x3F80, lsl #16
    fmov s0, w8
    
    // Load 2.0 into S1
    movz w9, #0x0000
    movk w9, #0x4000, lsl #16
    fmov s1, w9
    
    // FCMP: compare S0 with S1
    fcmp s0, s1
    
    // If less than, set x0 = 1
    cset x0, lt

    brk #0
