/* CONFIG
{
  "Match": "All",
  "VecData": {
    "V0": ["0x0204081020408080", "0x0000000000000000"]
  },
  "ExpectedRegData": {
    "X0": "0x0000000000000080",
    "X1": "0x0000000000000080",
    "X2": "0x0000000000000040",
    "X3": "0x0000000000000020"
  }
}
*/
// Test: umov instruction to extract bytes
// V0 = [128, 128, 64, 32, 16, 8, 4, 2, ...]

.text
.global _start
_start:
    umov w0, v0.b[0]  // should be 128
    umov w1, v0.b[1]  // should be 128
    umov w2, v0.b[2]  // should be 64
    umov w3, v0.b[3]  // should be 32
    brk #0
