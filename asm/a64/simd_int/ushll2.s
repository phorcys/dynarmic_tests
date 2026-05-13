/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000004000000030000000200000001"
}
*/
// Test: USHLL2 Vd.4S, Vn.8H, #shift - Unsigned Shift Left Long (high half)

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
    
    // USHLL2: shift left and widen from high half
    // [1,2,3,4] << 0 = [1,2,3,4] (widened to 32-bit)
    ushll2 v0.4s, v1.8h, #0
    
    brk #0
