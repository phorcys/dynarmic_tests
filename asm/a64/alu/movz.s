/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234"
  }
}
*/
// Test: MOVZ Xd, #imm - move wide with zero

.text
.global _start
_start:
    movz x0, #0x1234

    brk #0
