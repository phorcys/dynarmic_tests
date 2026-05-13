/* CONFIG
{
  "Match": "All",
  "D0": "0x0000FFFF00000001"
}
*/
// Test: SQSHRN Vd.2S, Vn.2D, #imm - Signed Saturating Shift Right Narrow

.text
.global _start
_start:
    // v0.2d = [0x0000000100000000, 0xFFFFFFFF80000000]
    mov x0, #0
    movk x0, #0x0001, lsl #32
    mov x1, #0x80000000
    movk x1, #0xFFFF, lsl #32
    mov v0.d[0], x0
    mov v0.d[1], x1
    
    // SQSHRN: shift right by 32, narrow to 32-bit
    // 0x0000000100000000 >> 32 = 0x00000001
    // 0xFFFFFFFF80000000 >> 32 = 0xFFFFFFFF
    sqshrn v0.2s, v0.2d, #32
    
    brk #0
