/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000010000"
  }
}
*/

.text
.global _start
_start:
    movz x0, #1, lsl #16
    brk #0

