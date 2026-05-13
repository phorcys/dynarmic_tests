/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF80"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0x80
    add x0, x0, x1, sxtb
    brk #0

