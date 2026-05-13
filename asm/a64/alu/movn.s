/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFEDCB"
  }
}
*/
// Test: MOVN Xd, #imm - move wide with NOT

.text
.global _start
_start:
    movn x0, #0x1234

    brk #0