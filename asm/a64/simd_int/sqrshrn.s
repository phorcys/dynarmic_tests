/* CONFIG
{
  "Match": "All",
  "D0": "0x0001000000000002"
}
*/
// Test: SQRSHRN Vd.2S, Vn.2D, #imm - Signed Saturating Rounding Shift Right Narrow

.text
.global _start
_start:
    // v0.2d = [0x0000000180000000, 0xFFFFFFFFC0000000]
    mov x0, #0x80000000
    movk x0, #0x0001, lsl #32
    mov x1, #0xC0000000
    movk x1, #0xFFFF, lsl #32
    mov v0.d[0], x0
    mov v0.d[1], x1
    
    // SQRSHRN: shift right by 32 with rounding, narrow to 32-bit
    // 0x0000000180000000 >> 32 (rounding) = 0x00000002
    // 0xFFFFFFFFC0000000 >> 32 (rounding) = 0xFFFFFFFF
    sqrshrn v0.2s, v0.2d, #32
    
    brk #0
