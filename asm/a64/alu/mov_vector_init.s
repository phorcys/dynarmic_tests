/* CONFIG
{
  "Match": "All",
  "ExpectedRegData": {
    "W0": "0x000000FF",
    "W1": "0x00000001"
  }
}
*/
// Test: verify mov to vector works

.text
.global _start
_start:
    // Initialize V0.b[0] = 255
    mov w2, #255
    mov v0.b[0], w2
    
    // Initialize V1.b[0] = 1
    mov w2, #1
    mov v1.b[0], w2
    
    // Extract to verify
    umov w0, v0.b[0]
    umov w1, v1.b[0]
    
    brk #0