/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000080"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    mov w1, #0x80
    add x0, x0, w1, sxtw
    brk #0

