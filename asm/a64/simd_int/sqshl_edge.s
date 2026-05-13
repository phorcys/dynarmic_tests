/* CONFIG
{
  "Match": "All",
  "X0": "0xFFFFFFFFFFFFFF80"
}
*/
// Test: -76 << 8 should saturate to INT8_MIN = -128
// -76 = 0xB4 in signed 8-bit
// Shift = 8, which is >= esize (8), so should saturate

.text
.global _start
_start:
    // a = -76 (signed 8-bit = 0xB4)
    mov w0, #180    // -76 as unsigned = 180
    sub w0, w0, #256  // w0 = -76
    mov w1, #8
    
    // Move to vector
    ins v0.b[0], w0
    ins v1.b[0], w1
    
    // SQSHL b0, b0, b1
    sqshl b0, b0, b1
    
    // Get result sign-extended
    smov x0, v0.b[0]
    
    brk #0
