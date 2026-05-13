/* CONFIG
{
  "Match": "All",
  "Q0": "0x7fffffff7fffffff0000000000000000"
}
*/
// Test: SQXTN2 Vd.4S, Vn.2D - Signed Saturating Extract Narrow (high half)

.text
.global _start
_start:
    // v1.2d = [0x0000000100000000, 0xFFFFFFFF80000000]
    mov x0, #0
    movk x0, #0x0001, lsl #32
    mov x1, #0x80000000
    movk x1, #0xFFFF, lsl #32
    mov v1.d[0], x0
    mov v1.d[1], x1
    
    // v0 = [0, 0] (lower half)
    movi v0.2s, #0
    
    // SQXTN2: extract signed narrow to upper half
    // 0x0000000100000000 -> saturates to 0x7FFFFFFF (positive overflow)
    // 0xFFFFFFFF80000000 -> 0x80000000
    sqxtn2 v0.4s, v1.2d
    
    brk #0
