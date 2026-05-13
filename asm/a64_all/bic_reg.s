/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000F"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0xF0
    bic x0, x0, x1
    brk #0

