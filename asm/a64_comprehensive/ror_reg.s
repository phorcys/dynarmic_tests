/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0F000000000000F0"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xF
    movk x0, #0xF000, lsl #48
    mov x1, #8
    ror x0, x0, x1
    brk #0

