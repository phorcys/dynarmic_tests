/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0xff00000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    bfi x1, x0, #32, #8
    brk #0

