/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000002"
}
*/
// Test: FCVTPS Xd, Sn - Floating-point Convert to Signed Integer (round toward +inf)
// Converts float to signed integer, rounding toward positive infinity

.text
.global _start
_start:
    fmov s0, #2.0
    
    // FCVTPS: convert float to Signed Integer (round toward +infinity)
    fcvtps x0, s0
    
    brk #0