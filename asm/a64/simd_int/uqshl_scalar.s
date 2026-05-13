/* CONFIG
{
  "Match": "All",
  "X0": "0x0"
}
*/
// Test UQSHL scalar B: a = 92, shift = -10
// Expected: 92 >> 10 = 0

.text
.global _start
_start:
    // a = 92, shift = -10
    mov w0, #92
    mov w1, #-10
    
    // Move to vector registers
    fmov s0, w0
    fmov s1, w1
    
    // UQSHL scalar B register
    uqshl b0, b0, b1
    
    // Read result (unsigned byte to w0)
    umov w0, v0.b[0]
    
    brk #0
