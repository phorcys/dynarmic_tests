/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000040000000000000002"
}
*/
// Test: SHRN2 Vd.4S, Vn.2D, #shift - Shift Right Narrow (high half)

.text
.global _start
_start:
    // v1.2d = [0x100000000, 0x200000000] (values that shift right to fit in 32-bit)
    mov x0, #0
    mov x1, #1
    lsl x1, x1, #32  // 0x100000000
    fmov d0, x0
    ins v1.d[0], x1
    mov x1, #2
    lsl x1, x1, #32  // 0x200000000
    ins v1.d[1], x1
    
    // SHRN2: shift right and narrow to high half
    // [0x100000000, 0x200000000] >> 32 = [1, 2]
    shrn2 v0.4s, v1.2d, #32
    
    brk #0
