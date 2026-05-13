/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    movk x1, #0, lsl #48
    tbz x1, #63, 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0

