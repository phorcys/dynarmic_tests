/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "W0": "1170",
    "W1": "1170",
    "W2": "1170"
  }
}
*/
.text
.global _start
_start:
    // Test data: a = -7721, b = -4968, expected = 1170
    
    // Load a and b
    mov w3, #0xE1D7
    movk w3, #0xFFFF, lsl #16   // w3 = -7721
    mov w4, #0xEC98
    movk w4, #0xFFFF, lsl #16   // w4 = -4968
    
    // Sign extend to 32-bit (simulating ext.w.h)
    sxth w5, w3   // w5 = -7721 (sign extended)
    sxth w6, w4   // w6 = -4968 (sign extended)
    
    // Multiply
    mul w7, w5, w6   // w7 = 38359128 (a * b)
    
    // Double
    lsl w8, w7, #1   // w8 = 76718256 (a * b * 2)
    
    // Get high 16 bits (>> 15 of x is same as >> 16 of 2x)
    lsr w1, w7, #15   // w1 = 1170 (expected result)
    
    // Now test SQDMULH
    ins v0.h[0], w3
    ins v1.h[0], w4
    sqdmulh h2, h0, h1
    smov w2, v2.H[0]
    
    // w0 should be 1170, w2 should also be 1170
    cmp w1, w2
    b.ne fail
    mov w0, w1
    brk #0
fail:
    mov w0, #0
    brk #0
