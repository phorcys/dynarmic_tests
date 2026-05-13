/* CONFIG
{
  "Match": "All",
  "D0": "0x0000000300000002"
}
*/
// Test: UQRSHRN Vd.2S, Vn.2D, #imm - Unsigned Saturating Rounding Shift Right Narrow

.text
.global _start
_start:
    // v0.2d = [0x0000000180000000, 0x0000000280000000]
    mov x0, #0x80000000
    movk x0, #0x0001, lsl #32
    mov x1, #0x80000000
    movk x1, #0x0002, lsl #32
    mov v0.d[0], x0
    mov v0.d[1], x1
    
    // UQRSHRN: shift right by 32 with rounding, narrow to 32-bit
    // 0x0000000180000000 >> 32 (rounding) = 0x00000002
    // 0x0000000280000000 >> 32 (rounding) = 0x00000003
    uqrshrn v0.2s, v0.2d, #32
    
    brk #0
