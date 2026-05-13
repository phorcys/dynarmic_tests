/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000002"
}
*/
// Test: SQSHRUN Vd.4H, Vn.4S, #amount - Signed Saturating Shift Right Unsigned Narrow
// Shifts right with saturation to unsigned and narrows

.text
.global _start
_start:
    mov w0, #16
    dup v0.4s, w0
    
    // SQSHRUN: signed saturating shift right unsigned narrow (4S -> 4H)
    // 16 >> 3 = 2
    sqshrun v0.4h, v0.4s, #3
    
    brk #0
