/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xF000000000000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xF
    ror x0, x0, #4
    brk #0

