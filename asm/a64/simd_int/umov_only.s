/* CONFIG
{
  "Match": "All",
  "VecData": {
    "V0": ["0x0204081020408080", "0x0000000000000000"]
  },
  "ExpectedRegData": {
    "X0": "0x0000000000000080",
    "X1": "0x0000000000000080"
  }
}
*/
// Test: just umov from preset V0 (no uhadd, no mov)

.text
.global _start
_start:
    umov w0, v0.b[0]  // should be 128
    umov w1, v0.b[1]  // should be 128
    brk #0
