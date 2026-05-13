/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x000000000000FF78"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0x5678
    movk x1, #0x1234, lsl #16
    bfxil x1, x0, #0, #8
    brk #0

