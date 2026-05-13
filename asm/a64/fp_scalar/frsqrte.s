/* CONFIG
{
  "Match": "All",
  "S0": "0x3F800000",
  "S1": "0x3F3504F3"
}
*/
// Test: FRSQRTE Sd, Sn - Floating-point Reciprocal Square Root Estimate
// Computes approximate 1/sqrt(x)

.text
.global _start
_start:
    // FRSQRTE of 1.0 ≈ 1.0
    mov w0, #0x3F800000   // 1.0 in single
    fmov s0, w0
    frsqrte s0, s0
    // S0 ≈ 1.0
    
    // FRSQRTE of 4.0 ≈ 0.5
    mov w1, #0x40800000   // 4.0 in single
    fmov s1, w1
    frsqrte s1, s1
    // S1 ≈ 0.5 (1/sqrt(4) = 0.5)

    brk #0
