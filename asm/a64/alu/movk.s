/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000056781234"
  }
}
*/
// Test: MOVK Xd, #imm, lsl #shift - move wide with keep

.text
.global _start
_start:
    movz x0, #0x1234
    movk x0, #0x5678, lsl #16

    brk #0
