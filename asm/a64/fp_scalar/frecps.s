/* CONFIG
{
  "Match": "All",
  "S0": "0x3F800000"
}
*/
// Test: FRECPS Sd, Sn, Sm - Floating-point Reciprocal Step
// Used for Newton-Raphson refinement: d = 2 - n * m

.text
.global _start
_start:
    // FRECPS(1.0, 1.0) = 2 - 1.0 * 1.0 = 1.0
    mov w0, #0x3F800000   // 1.0 in single
    fmov s0, w0
    mov w1, #0x3F800000   // 1.0 in single
    fmov s1, w1
    
    frecps s0, s0, s1
    // S0 = 2.0 - 1.0 * 1.0 = 1.0

    brk #0
