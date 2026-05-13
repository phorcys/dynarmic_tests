/* CONFIG
{
  "Match": "All",
  "W0": "0xFF"
}
*/
// Test UQSHL scalar B: a = 15, shift = 14
// Expected: 15 << 14 = overflow -> UINT8_MAX = 255

.text
.global _start
_start:
    // a = 15, shift = 14
    mov w0, #15
    mov w1, #14
    
    // Move to vector registers
    fmov s0, w0
    fmov s1, w1
    
    // UQSHL scalar B register
    uqshl b0, b0, b1
    
    // Read result (unsigned byte to w0)
    umov w0, v0.b[0]
    
    brk #0
