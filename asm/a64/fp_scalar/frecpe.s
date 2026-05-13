/* CONFIG
{
  "Match": "All",
  "S0": "0x3F800000",
  "S1": "0x3F000000"
}
*/
// Test: FRECPE Sd, Sn - Floating-point Reciprocal Estimate
// Computes approximate reciprocal (1/x)

.text
.global _start
_start:
    // FRECPE of 1.0 ≈ 1.0
    mov w0, #0x3F800000   // 1.0 in single
    fmov s0, w0
    frecpe s0, s0
    // S0 ≈ 1.0
    
    // FRECPE of 2.0 ≈ 0.5
    mov w1, #0x40000000   // 2.0 in single
    fmov s1, w1
    frecpe s1, s1
    // S1 ≈ 0.5

    brk #0
