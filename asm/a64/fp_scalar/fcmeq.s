/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFF0000000000000000"
}
*/
// Test: FCMEQ Vd.2D, Vn.2D, Vm.2D - Floating-point Compare Equal
// Sets destination element to all 1s if equal, all 0s otherwise

.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #1.0
    fmov d2, #2.0
    
    // FCMEQ: compare equal
    // D0 == D1 -> all 1s
    // D0 == D2 -> all 0s (but we only compare D0 with D1)
    fcmeq v0.2d, v0.2d, v1.2d
    
    brk #0