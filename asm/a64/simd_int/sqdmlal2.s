/* CONFIG
{
  "Match": "All",
  "Q0": "0x000000000000000A0000000000000002"
}
*/
// Test: SQDMLAL2 Vd.4S, Vn.8H, Vm.8H - Signed Saturating Doubling Multiply Accumulate Long (upper)
// Uses upper half of 8H vectors

.text
.global _start
_start:
    // Setup: v0.4s = [1, 2, 0, 0]
    mov w0, #1
    dup v0.4s, w0
    mov w0, #2
    ins v0.s[1], w0
    
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
    
    // SQDMLAL2: v0 += upper(v1) * upper(v2) * 2
    // v0[0] = 1 + 1*1*2 = 3, v0[1] = 2 + 2*2*2 = 10
    sqdmlal2 v0.4s, v1.8h, v2.8h
    
    brk #0
