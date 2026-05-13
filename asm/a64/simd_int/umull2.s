/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000040000000000000002"
}
*/
// Test: UMULL2 Vd.4S, Vn.8H, Vm.8H - Unsigned Multiply Long (high half)

.text
.global _start
_start:
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
    
    // v2.8h = [0,0,0,0,2,2,2,2] (high half)
    mov w0, #0
    dup v2.8h, w0
    mov w0, #2
    ins v2.h[4], w0
    ins v2.h[5], w0
    ins v2.h[6], w0
    ins v2.h[7], w0
    
    // UMULL2: v0 = v1[4-7] * v2[4-7]
    // [1,2,3,4] * [2,2,2,2] = [2, 4, 6, 8]
    umull2 v0.4s, v1.8h, v2.8h
    
    brk #0
