/* CONFIG
{
  "Match": "All",
  "VecData": {
    "V2": ["0x0204081020408080", "0x0000000000000000"]
  },
  "ExpectedRegData": {
    "X4": "0x0000000000000080",  // V2.B[0]
    "X5": "0x0000000000000080",  // V2.B[1]
    "X6": "0x0204081020408080"   // V2.D[0]
  }
}
*/
// Test: compare umov.b vs fmov.d from same register

.text
.global _start
_start:
    // umov extracts byte elements
    umov w4, v2.b[0]
    umov w5, v2.b[1]
    // fmov extracts entire 64-bit
    fmov x6, d2
    brk #0
