/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFE0000000000000000"
}
*/
// Test: SQDMLSL2 Vd.4S, Vn.8H, Vm.8H - Signed Saturating Doubling Multiply Subtract Long (upper)
// Uses upper half of 8H vectors

.text
.global _start
_start:
    // Setup: v0.4s = [10, 20, 0, 0]
    mov w0, #10
    dup v0.4s, w0
    mov w0, #20
    ins v0.s[1], w0
    
    // v1.8h = [0,0,0,0,2,3,0,0]
    mov w0, #2
    ins v1.h[4], w0
    mov w0, #3
    ins v1.h[5], w0
    
    // v2.8h = [0,0,0,0,2,3,0,0]
    mov v2.16b, v1.16b
    
    // SQDMLSL2: v0 -= upper(v1) * upper(v2) * 2
    // v0[0] = 10 - 2*2*2 = 2, v0[1] = 20 - 3*3*2 = 2
    sqdmlsl2 v0.4s, v1.8h, v2.8h
    
    brk #0
