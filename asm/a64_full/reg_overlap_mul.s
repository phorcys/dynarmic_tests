/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000010"
  }
}
*/

.text
.global _start
_start:
    mov x0, #2
    mul x0, x0, x0
    mul x0, x0, x0
    brk #0

