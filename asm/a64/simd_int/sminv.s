/* CONFIG
{
  "Match": "All",
  "S0": "0x00000001"
}
*/
// Test: SMINV Sd, Vn.4H - Signed Minimum across Vector
// Finds minimum of all signed 16-bit elements

.text
.global _start
_start:
    // v0.4h = [5,3,1,7]
    mov w0, #5
    dup v0.4h, w0
    mov w0, #3
    ins v0.h[1], w0
    mov w0, #1
    ins v0.h[2], w0
    mov w0, #7
    ins v0.h[3], w0
    
    // SMINV: find minimum = 1
    sminv h0, v0.4h
    
    brk #0
