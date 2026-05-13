/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000003D"
  }
}
*/

.text
.global _start
_start:
    mov x0, #2
    cls x0, x0
    brk #0

