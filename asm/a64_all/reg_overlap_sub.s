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
    mov x0, #5
    sub x0, x0, x0
    brk #0

