/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000040000000000000002"
}
*/
// Test: UADDL2 Vd.4S, Vn.8H, Vm.8H - Unsigned Add Long (upper)
// Adds upper halves of two 8H vectors, producing 4S result

.text
.global _start
_start:
    // Setup: v0.8h = [1,2,3,4,5,6,7,8], v1.8h = [1,2,3,4,5,6,7,8]
    mov w0, #1
    dup v0.8h, w0
    mov w0, #2
    ins v0.h[1], w0
    mov w0, #3
    ins v0.h[2], w0
    mov w0, #4
    ins v0.h[3], w0
    mov w0, #5
    ins v0.h[4], w0
    mov w0, #6
    ins v0.h[5], w0
    mov w0, #7
    ins v0.h[6], w0
    mov w0, #8
    ins v0.h[7], w0
    
    mov v1.16b, v0.16b
    
    // UADDL2: add upper halves (elements 4-7)
    uaddl2 v0.4s, v0.8h, v1.8h
    
    brk #0
