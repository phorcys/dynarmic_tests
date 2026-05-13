/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFB"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    mov x1, #2
    mov x2, #3
    msub x0, x1, x2, x0
    brk #0

