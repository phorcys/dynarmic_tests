/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000002"
}
*/
// Test: FCVTNS Xd, Sn - Floating-point Convert to Signed Integer (round to nearest)
// Converts float to signed integer, rounding to nearest

.text
.global _start
_start:
    fmov s0, #2.0
    
    // FCVTNS: convert float to Signed Integer (round to Nearest)
    fcvtns x0, s0
    
    brk #0