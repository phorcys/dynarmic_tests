/* CONFIG
{
  "Match": "All",
  "S0": "0x00000007"
}
*/
// Test: SMAXV Sd, Vn.4H - Signed Maximum across Vector
// Finds maximum of all signed 16-bit elements

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
    
    // SMAXV: find maximum = 7
    smaxv h0, v0.4h
    
    brk #0
