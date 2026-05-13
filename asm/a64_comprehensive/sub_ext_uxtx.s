/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000007FFF"
  }
}
*/

.text
.global _start
_start:
    mov x1, #0xFF
    movk x1, #0xFF00, lsl #16  // x1 = 0x00FF0000FF
    mov x0, #0x8000
    sub x0, x0, x1, uxtx
    brk #0

