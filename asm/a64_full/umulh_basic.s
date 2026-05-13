/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/

.text
.global _start
_start:
    mov x1, #0xFFFFFFFF
    mov x2, #0xFFFFFFFF
    umulh x0, x1, x2
    brk #0

