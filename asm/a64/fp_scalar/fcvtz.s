/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000002"
}
*/
// Test: FCVTZS Xd, Sn - Floating-point Convert to Signed Integer
// Converts float to signed integer

.text
.global _start
_start:
    fmov s0, #2.0
    
    // FCVTZS: convert float to Signed Integer (round toward Zero)
    fcvtzs x0, s0
    
    brk #0