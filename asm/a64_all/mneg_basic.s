/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFA"
  }
}
*/

.text
.global _start
_start:
    mov x1, #2
    mov x2, #3
    mneg x0, x1, x2
    brk #0

