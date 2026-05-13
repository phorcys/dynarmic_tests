/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000006"
  }
}
*/

.text
.global _start
_start:
    mov x0, #2
    mov x1, #3
    mul x0, x0, x1
    brk #0

