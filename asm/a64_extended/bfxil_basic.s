/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000FF00"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xFF00
    mov x1, #0x00
    bfxil x1, x0, #0, #16
    brk #0

