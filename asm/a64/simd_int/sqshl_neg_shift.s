/* CONFIG
{
  "Match": "All",
  "X0": "0xFFFFFFFFFFFFFFFF"
}
*/
// Test SQSHL scalar B: a = -1, shift = -1
// Expected: -1 >> 1 = -1 (arithmetic right shift)

.text
.global _start
_start:
    // a = -1 (0xFF in signed 8-bit)
    mov w0, #255
    ins v0.b[0], w0
    
    // shift = -1 (0xFF in signed 8-bit)
    mov w1, #255
    ins v1.b[0], w1
    
    // SQSHL b0, b0, b1
    sqshl b0, b0, b1
    
    // Get result sign-extended
    smov x0, v0.b[0]
    
    brk #0
