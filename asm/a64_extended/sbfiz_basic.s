/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF00"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xF
    sbfiz x0, x0, #4, #4
    brk #0

