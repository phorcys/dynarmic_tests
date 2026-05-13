/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000008000000080000000400000002"
}
*/
// Test: SQRSHRUN2 Vd.4S, Vn.2D, #shift - Signed Saturating Rounding Shift Right Unsigned Narrow (high half)

.text
.global _start
_start:
    // v1.2d = [16, 32] (values that shift right to fit in 32-bit unsigned)
    mov x0, #16
    fmov d1, x0
    mov x0, #32
    ins v1.d[1], x0
    
    // SQRSHRUN2: signed saturating rounding shift right unsigned narrow to high half
    // [16, 32] >> 1 = [8, 16]
    sqrshrun2 v0.4s, v1.2d, #1
    
    brk #0