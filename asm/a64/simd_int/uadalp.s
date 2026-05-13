/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000070000000000000005"
}
*/
// Test: UADALP Vd.4S, Vn.8H - Unsigned Add and Accumulate Long Pairwise
// Adds pairwise and accumulates into destination

.text
.global _start
_start:
    // Setup: v0.4s = [1, 2, 3, 4] (accumulator)
    mov w0, #1
    dup v0.4s, w0
    mov w0, #2
    ins v0.s[1], w0
    mov w0, #3
    ins v0.s[2], w0
    mov w0, #4
    ins v0.s[3], w0
    
    // v1.8h = [1,2,3,4,5,6,7,8]
    mov w0, #1
    dup v1.8h, w0
    mov w0, #2
    ins v1.h[1], w0
    mov w0, #3
    ins v1.h[2], w0
    mov w0, #4
    ins v1.h[3], w0
    mov w0, #5
    ins v1.h[4], w0
    mov w0, #6
    ins v1.h[5], w0
    mov w0, #7
    ins v1.h[6], w0
    mov w0, #8
    ins v1.h[7], w0
    
    // UADALP: accumulate pairwise add
    // v0 += [3, 7, 11, 15] = [4, 9, 14, 19]
    uadalp v0.4s, v1.8h
    
    brk #0
