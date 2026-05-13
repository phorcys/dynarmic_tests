/* CONFIG
{
  "Match": "All",
  "VecData": {
    "V2": ["0x0204081020408080", "0x0000000000000000"]
  },
  "ExpectedRegData": {
    "X4": "0x0000000000000080",
    "X5": "0x0000000000000080"
  }
}
*/
// Test: umov from V2 directly

.text
.global _start
_start:
    umov w4, v2.b[0]
    umov w5, v2.b[1]
    brk #0
