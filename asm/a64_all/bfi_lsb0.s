/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0xff"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    bfi x1, x0, #0, #8
    brk #0

