/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000004000000080000000200000004"
}
*/
// Test: SQDMULL2 Vd.4S, Vn.8H, Vm.8H - Signed Saturating Double Multiply Long (high)
// Multiplies upper 16-bit values to 32-bit with doubling

.text
.global _start
_start:
    // Setup: create 8-element vectors
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #4
    ins v0.h[4], w0
    ins v0.h[5], w1
    ins v0.h[6], w2
    ins v0.h[7], w3
    ins v1.h[4], w0
    ins v1.h[5], w1
    ins v1.h[6], w2
    ins v1.h[7], w3
    
    // SQDMULL2: signed saturating double multiply long (upper halves)
    sqdmull2 v0.4s, v0.8h, v1.8h
    
    brk #0
