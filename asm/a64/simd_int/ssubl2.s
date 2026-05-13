/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000020000000000000000"
}
*/
// Test: SSUBL2 Vd.4S, Vn.8H, Vm.8H - Signed Subtract Long (upper)
// Subtracts upper halves of two 8H vectors

.text
.global _start
_start:
    // Setup: v0.8h = [5,6,7,8,9,10,11,12]
    mov w0, #5
    dup v0.8h, w0
    mov w0, #6
    ins v0.h[1], w0
    mov w0, #7
    ins v0.h[2], w0
    mov w0, #8
    ins v0.h[3], w0
    mov w0, #9
    ins v0.h[4], w0
    mov w0, #10
    ins v0.h[5], w0
    mov w0, #11
    ins v0.h[6], w0
    mov w0, #12
    ins v0.h[7], w0
    
    // v1.8h = [1,2,3,4,5,6,7,8]
    mov w0, #5
    dup v1.8h, w0
    mov w0, #6
    ins v1.h[1], w0
    mov w0, #7
    ins v1.h[2], w0
    mov w0, #8
    ins v1.h[3], w0
    
    // SSUBL2: subtract upper halves
    // v0.4s = [9-5, 10-6, 11-7, 12-8] = [4, 4, 4, 4]
    ssubl2 v0.4s, v0.8h, v1.8h
    
    brk #0
