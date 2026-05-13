/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000050000000000000003"
}
*/
// Test: SADDLP Vd.4S, Vn.8H - Signed Add Long Pairwise
// Adds adjacent pairs of signed 16-bit values, producing 32-bit results

.text
.global _start
_start:
    // Setup: v0.8h = [1,2,3,4,5,6,7,8]
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
    
    // SADDLP: add pairwise (1+2, 3+4, 5+6, 7+8) = [3, 7, 11, 15]
    saddlp v0.4s, v0.8h
    
    brk #0
