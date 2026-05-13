/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000080000000000000002"
}
*/
// Test: SQDMULL2 Vd.4S, Vn.8H, Vm.8H - Signed Saturating Doubling Multiply Long (upper)
// Uses upper half of 8H vectors

.text
.global _start
_start:
    // v1.8h = [0,0,0,0,1,2,3,4]
    mov w0, #1
    ins v1.h[4], w0
    mov w0, #2
    ins v1.h[5], w0
    mov w0, #3
    ins v1.h[6], w0
    mov w0, #4
    ins v1.h[7], w0
    
    // v2.8h = [0,0,0,0,1,2,3,4]
    mov v2.16b, v1.16b
    
    // SQDMULL2: v0 = upper(v1) * upper(v2) * 2
    // v0[0] = 1*1*2 = 2, v0[1] = 2*2*2 = 8
    sqdmull2 v0.4s, v1.8h, v2.8h
    
    brk #0
