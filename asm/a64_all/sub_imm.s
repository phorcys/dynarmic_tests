/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFF8"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    sub x0, x0, #8
    brk #0

