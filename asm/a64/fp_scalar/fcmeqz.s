/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFF0000000000000000"
}
*/
// Test: FCMEQ Vd.2D, Vn.2D, #0.0 - Floating-point Compare Equal to Zero
// Sets destination element to all 1s if equal to zero, all 0s otherwise

.text
.global _start
_start:
    mov x0, #0
    fmov d0, x0        // d0 = 0.0
    fmov d1, #1.0
    
    // FCMEQ with zero: compare equal to zero
    // D0 == 0.0 -> all 1s
    // D1 == 0.0 -> all 0s (but we store result in V0)
    fcmeq v0.2d, v0.2d, #0.0
    
    brk #0