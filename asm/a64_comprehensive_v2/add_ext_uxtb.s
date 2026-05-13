/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000FF"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0xFF
    add x0, x0, x1, uxtb
    brk #0

