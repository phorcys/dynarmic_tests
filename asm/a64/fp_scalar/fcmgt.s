/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFF0000000000000000"
}
*/
// Test: FCMGT Vd.2D, Vn.2D, Vm.2D - Floating-point Compare Greater Than
// Sets destination element to all 1s if Vn > Vm, all 0s otherwise

.text
.global _start
_start:
    fmov d0, #2.0
    fmov d1, #1.0
    fmov d2, #3.0
    
    // FCMGT: compare greater than
    // D0 > D1 (2.0 > 1.0) -> all 1s
    // D0 > D2 (2.0 > 3.0) -> all 0s (but we only compare with D1)
    fcmgt v0.2d, v0.2d, v1.2d
    
    brk #0