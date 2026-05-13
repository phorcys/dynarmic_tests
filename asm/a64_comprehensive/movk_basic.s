/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x123456789ABCDEF0"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xDEF0
    movk x0, #0x9ABC, lsl #16
    movk x0, #0x5678, lsl #32
    movk x0, #0x1234, lsl #48
    brk #0

