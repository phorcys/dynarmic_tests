/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000002"
}
*/
// Test: SQRSHRUN Vd.4H, Vn.4S, #amount - Signed Saturating Rounding Shift Right Unsigned Narrow
// Shifts right with saturation and rounding to unsigned, then narrows

.text
.global _start
_start:
    mov w0, #17
    dup v0.4s, w0
    
    // SQRSHRUN: signed saturating rounding shift right unsigned narrow (4S -> 4H)
    // 17 >> 3 = 2 (with rounding: 17/8 = 2.125 -> 2)
    sqrshrun v0.4h, v0.4s, #3
    
    brk #0
