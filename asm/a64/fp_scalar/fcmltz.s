/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000000000000FFFFFFFFFFFFFFFF"
}
*/
// Test: FCMLT Vd.2D, Vn.2D, #0.0 - Floating-point Compare Less Than Zero
// Sets destination element to all 1s if < 0.0, all 0s otherwise

.text
.global _start
_start:
    fmov d0, #-1.0
    fmov d1, #1.0
    
    // FCMLT with zero: compare less than zero
    // D0 < 0.0 (-1.0 < 0.0) -> all 1s
    // D1 < 0.0 (1.0 < 0.0) -> all 0s
    fcmlt v0.2d, v0.2d, #0.0
    
    brk #0
