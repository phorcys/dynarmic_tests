/* CONFIG
{
  "Match": "All",
  "ExpectedRegData": {
    "X0": "0x00000000000000FF",
    "X1": "0x0000000000000080"
  }
}
*/
// Test: mov v.b[idx], w instruction

.text
.global _start
_start:
    mov w0, #255
    mov v0.b[0], w0
    mov w0, #128
    mov v0.b[1], w0
    
    umov w0, v0.b[0]  // should be 255
    umov w1, v0.b[1]  // should be 128
    brk #0
