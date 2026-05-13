/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x0000000000000492",
    "W1": "1170",
    "W2": "1170"
  }
}
*/
.text
.global _start
_start:
    // Load h0 = -7721, h1 = -4968 using mov
    mov w3, #0xE1D7
    movk w3, #0xFFFF, lsl #16   // w3 = -7721
    
    mov w4, #0xEC98
    movk w4, #0xFFFF, lsl #16   // w4 = -4968
    
    fmov s0, w3
    fmov s1, w4
    
    // SQDMULH h2, h0, h1 should give 1170 = 0x0492
    sqdmulh h2, h0, h1
    smov w2, v2.H[0]    // w2 = result
    
    // Check
    mov w0, w2
    brk #0
