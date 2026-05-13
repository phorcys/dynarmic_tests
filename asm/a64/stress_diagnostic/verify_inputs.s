/* CONFIG
{
  "Match": "All",
  "ExpectedRegData": {
    "W0": "0x000000FF",
    "W1": "0x00000001",
    "W2": "0x00000001",
    "W3": "0x000000FE"
  }
}
*/
// Test: Verify input values for uhadd overflow test

.text
.global _start
_start:
    // Initialize V0.b[0] = 255
    mov w4, #255
    mov v0.b[0], w4
    
    // Initialize V1.b[0] = 1
    mov w4, #1
    mov v1.b[0], w4
    
    // Verify V0.b[0] = 255
    umov w0, v0.b[0]
    
    // Verify V1.b[0] = 1
    umov w1, v1.b[0]
    
    // Compute XOR and verify
    // V2 = V0 ^ V1, V2.b[0] = 255 ^ 1 = 254
    eor v2.16b, v0.16b, v1.16b
    umov w3, v2.b[0]
    
    // Compute AND and verify
    // V3 = V0 & V1, V3.b[0] = 255 & 1 = 1
    and v3.16b, v0.16b, v1.16b
    umov w2, v3.b[0]
    
    brk #0
