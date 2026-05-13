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
    mov x1, #1
    movk x1, #0x1, lsl #32
    mov x2, #1
    movk x2, #0x1, lsl #32
    umulh x0, x1, x2
    brk #0
