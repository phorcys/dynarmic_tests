/* CONFIG
{
  "Match": "All",
  "S0": "0x40000000"
}
*/
// Test: FRSQRTS Sd, Sn, Sm - Floating-point Reciprocal Square Root Step
// Used for Newton-Raphson refinement: d = (3 - n * m) / 2

.text
.global _start
_start:
    // FRSQRTS(1.0, 1.0) = (3 - 1.0 * 1.0) / 2 = 1.0
    mov w0, #0x3F800000   // 1.0 in single
    fmov s0, w0
    mov w1, #0x3F800000   // 1.0 in single
    fmov s1, w1
    
    frsqrts s0, s0, s1
    // S0 = (3 - 1 * 1) / 2 = 1.0

    brk #0
