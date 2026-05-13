/* CONFIG
{
  "Match": "All",
  "D0": "0x0000000200000001"
}
*/
// Test: UQSHRN Vd.2S, Vn.2D, #imm - Unsigned Saturating Shift Right Narrow

.text
.global _start
_start:
    // v0.2d = [0x0000000100000000, 0x0000000200000000]
    mov x0, #0
    movk x0, #0x0001, lsl #32
    mov x1, #0
    movk x1, #0x0002, lsl #32
    mov v0.d[0], x0
    mov v0.d[1], x1
    
    // UQSHRN: shift right by 32, narrow to 32-bit
    // 0x0000000100000000 >> 32 = 0x00000001
    // 0x0000000200000000 >> 32 = 0x00000002
    uqshrn v0.2s, v0.2d, #32
    
    brk #0
