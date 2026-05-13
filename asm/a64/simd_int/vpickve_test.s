/* CONFIG
{
  "Match": "All",
  "VecData": {
    "V0": ["0x02040810204080FF", "0x0000000000000000"]
  },
  "ExpectedRegData": {
    "X0": "0x00000000000000FF",
    "X1": "0x0000000000000080"
  }
}
*/
// Test: vpickve2gr.bu directly via umov

.text
.global _start
_start:
    umov w0, v0.b[0]  // Should be 0xFF = 255
    umov w1, v0.b[1]  // Should be 0x80 = 128
    brk #0
