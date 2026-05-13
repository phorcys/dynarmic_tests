/* CONFIG
{
  "Match": "All",
  "Q0": "0xffffffffffffffff0000000000000000"
}
*/
// Test: SQXTUN2 Vd.4S, Vn.2D - Signed Saturating Extract Unsigned Narrow (high half)

.text
.global _start
_start:
    // v0 = already has lower half, we set upper half
    // v1.2d = [0x0000000100000000, 0xFFFFFFFF80000000]
    mov x0, #0
    movk x0, #0x0001, lsl #32
    mov x1, #0x80000000
    movk x1, #0xFFFF, lsl #32
    mov v1.d[0], x0
    mov v1.d[1], x1
    
    // v0 = [0, 0] (lower half)
    movi v0.2s, #0
    
    // SQXTUN2: extract unsigned narrow to upper half
    // 0x0000000100000000 -> 0x00000001 (saturates to 0xFFFFFFFF? no, it's positive)
    // 0xFFFFFFFF80000000 -> 0x80000000 (negative, saturates to 0)
    sqxtun2 v0.4s, v1.2d
    
    brk #0
