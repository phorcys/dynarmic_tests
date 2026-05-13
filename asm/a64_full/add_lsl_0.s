/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x2"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    add x0, x0, x1, lsl #0
    brk #0

