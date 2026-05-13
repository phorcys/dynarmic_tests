/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "W0": "0x496",
    "W1": "0xFFFFEC88"
  }
}
*/
.text
.global _start
_start:
    // Test SQDMULH scalar 16-bit: a = -7721, b = -4968
    // a = -7721 = 0xFFFFE1D7 (sign extended to 32-bit)
    // b = -4968 = 0xFFFFEC88 (sign extended to 32-bit)
    // Expected result: 1170
    
    mov w0, #0xE1D7
    movk w0, #0xFFFF, lsl #16   // w0 = 0xFFFFE1D7 = -7721
    mov w1, #0xEC88
    movk w1, #0xFFFF, lsl #16   // w1 = 0xFFFFEC88 = -4968
    
    ins v0.h[0], w0
    ins v1.h[0], w1
    sqdmulh h2, h0, h1   // SQDMULH 16-bit scalar
    smov w0, v2.H[0]     // Move result to w0 (sign extended)
    brk #0
