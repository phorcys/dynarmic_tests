/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000008000000060000000400000002"
}
*/
// Test: SHLL2 Vd.4S, Vn.8H, #shift - Shift Left Long (high half)
// Note: SHLL2 is an alias for SSHLL2

.text
.global _start
_start:
    // v1.8h = [0,0,0,0,1,2,3,4] (high half only matters)
    mov w0, #0
    dup v1.8h, w0
    mov w0, #1
    ins v1.h[4], w0
    mov w0, #2
    ins v1.h[5], w0
    mov w0, #3
    ins v1.h[6], w0
    mov w0, #4
    ins v1.h[7], w0
    
    // SSHLL2: shift left by 1 and widen from high half
    // [1,2,3,4] << 1 = [2,4,6,8]
    sshll2 v0.4s, v1.8h, #1
    
    brk #0
