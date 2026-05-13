/* CONFIG
{
  "Match": "All",
  "X0": "0xFFFFFFFFFFFFFF80"
}
*/
// Test SQSHL scalar B register: a = -76, shift = 8
// Expected: INT8_MIN = 0x80 = -128 (sign-extended to 64-bit: 0xFFFFFFFFFFFFFF80)

.text
.global _start
_start:
    // Setup: a = -76, shift = 8
    mov w0, #-76
    mov w1, #8
    
    // Move to vector registers
    fmov s0, w0
    fmov s1, w1
    
    // SQSHL scalar B register: d = a << shift with saturation
    sqshl b0, b0, b1
    
    // Read result (sign-extended)
    smov x0, v0.b[0]
    
    brk #0
