/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000030000000000000001"
}
*/
// Test: UMLSL2 Vd.4S, Vn.8H, Vm.8H - Unsigned Multiply Subtract Long (high half)
// v0 = v0 - (v1.h[4-7] * v2.h[4-7])

.text
.global _start
_start:
    // Setup: v0.4s = [5, 5, 5, 5] (accumulator)
    mov w0, #5
    dup v0.4s, w0
    
    // v1.8h = [0,0,0,0,1,2,3,4] (high half)
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
    
    // v2.8h = [0,0,0,0,1,1,1,1] (high half)
    mov w0, #0
    dup v2.8h, w0
    mov w0, #1
    ins v2.h[4], w0
    ins v2.h[5], w0
    ins v2.h[6], w0
    ins v2.h[7], w0
    
    // UMLSL2: v0 = v0 - (v1[4-7] * v2[4-7])
    // [5, 5, 5, 5] - ([1,2,3,4] * [1,1,1,1]) = [4, 3, 2, 1]
    umlsl2 v0.4s, v1.8h, v2.8h
    
    brk #0
