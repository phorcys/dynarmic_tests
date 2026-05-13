/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0x1234
    mov x1, #0
    extr x0, x1, x0, #0
    brk #0

