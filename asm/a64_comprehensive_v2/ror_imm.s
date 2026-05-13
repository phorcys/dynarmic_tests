/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1000000000000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    ror x0, x0, #4
    brk #0

