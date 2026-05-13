/* CONFIG
{
  "Match": "All",
  "VecData": {
    "V0": ["0x02040810204080FF", "0x0000000000000000"],
    "V1": ["0x0305091121418001", "0x0000000000000000"]
  },
  "ExpectedRegData": {
    "X0": "0x00000000000000FF",
    "X1": "0x0000000000000080",
    "X2": "0x0000000000000001",
    "X3": "0x0000000000000080"
  }
}
*/
// Test: verify VecData is correctly set before uhadd
// V0.b[0] = 255, V0.b[1] = 128
// V1.b[0] = 1, V1.b[1] = 128
// After umov: w0=255, w1=128, w2=1, w3=128

.text
.global _start
_start:
    umov w0, v0.b[0]  // should be 255
    umov w1, v0.b[1]  // should be 128
    umov w2, v1.b[0]  // should be 1
    umov w3, v1.b[1]  // should be 128
    brk #0