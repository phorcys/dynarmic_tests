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
    mov x0, #0xF0
    mov x1, #0x0F
    eon x0, x0, x1
    brk #0

