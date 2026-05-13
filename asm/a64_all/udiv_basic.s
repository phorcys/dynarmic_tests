/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000004"
  }
}
*/

.text
.global _start
_start:
    mov x0, #12
    mov x1, #3
    udiv x0, x0, x1
    brk #0

