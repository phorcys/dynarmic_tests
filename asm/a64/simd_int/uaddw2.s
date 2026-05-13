/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000060000000000000004"
}
*/
// Test: UADDW2 Vd.4S, Vn.4S, Vm.8H - Unsigned Add Wide (upper)
// Adds upper half of 8H vector to 4S vector

.text
.global _start
_start:
    // Setup: v0.4s = [1, 2, 3, 4]
    mov w0, #1
    dup v0.4s, w0
    mov w0, #2
    ins v0.s[1], w0
    mov w0, #3
    ins v0.s[2], w0
    mov w0, #4
    ins v0.s[3], w0
    
    // v1.8h = [1,2,3,4,5,6,7,8]
    mov w0, #5
    dup v1.8h, w0
    mov w0, #6
    ins v1.h[1], w0
    mov w0, #7
    ins v1.h[2], w0
    mov w0, #8
    ins v1.h[3], w0
    
    // UADDW2: add upper half of v1 to v0
    uaddw2 v0.4s, v0.4s, v1.8h
    
    brk #0
