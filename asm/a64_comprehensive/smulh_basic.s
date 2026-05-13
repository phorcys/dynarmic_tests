/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/

.text
.global _start
_start:
    mov x1, #0x8000
    movk x1, #0, lsl #16
    mov x2, #2
    smulh x0, x1, x2
    brk #0

