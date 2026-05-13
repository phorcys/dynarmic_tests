/* CONFIG
{
  "Match": "All",
  "H0": "0x0024"
}
*/
// Test: ADDV Hd, Vn.8H - Add across Vector
// Sums all 16-bit elements, produces 16-bit result

.text
.global _start
_start:
    // v0.8h = [1,2,3,4,5,6,7,8]
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
    
    // ADDV: sum all elements = 1+2+3+4+5+6+7+8 = 36
    addv h0, v0.8h
    
    brk #0
