/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFC0000000000000004"
}
*/
// Test: SSUBW2 Vd.4S, Vn.4S, Vm.8H - Signed Subtract Wide (upper)
// Subtracts upper half of 8H vector from 4S vector

.text
.global _start
_start:
    // Setup: v0.4s = [5, 6, 7, 8]
    mov w0, #5
    dup v0.4s, w0
    mov w0, #6
    ins v0.s[1], w0
    mov w0, #7
    ins v0.s[2], w0
    mov w0, #8
    ins v0.s[3], w0
    
    // v1.8h = [1,2,3,4,1,2,3,4]
    mov w0, #1
    dup v1.8h, w0
    mov w0, #2
    ins v1.h[1], w0
    ins v1.h[5], w0
    mov w0, #3
    ins v1.h[2], w0
    ins v1.h[6], w0
    mov w0, #4
    ins v1.h[3], w0
    ins v1.h[7], w0
    
    // SSUBW2: subtract upper half of v1 from v0
    // v0.4s = [5-1, 6-2, 7-3, 8-4] = [4, 4, 4, 4]
    ssubw2 v0.4s, v0.4s, v1.8h
    
    brk #0
