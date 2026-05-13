/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "W0": "1174"
  }
}
*/
.text
.global _start
_start:
    // Load -7721 and -4968
    mov w1, #0xE1D7
    movk w1, #0xFFFF, lsl #16   // w1 = -7721
    mov w2, #0xEC88
    movk w2, #0xFFFF, lsl #16   // w2 = -4968
    
    // Move to V registers (low 16 bits)
    ins v0.h[0], w1
    ins v1.h[0], w2
    
    // SQDMULH h0, h0, h1
    sqdmulh h0, h0, h1
    
    // Move result to GPR
    smov w0, v0.H[0]
    brk #0
