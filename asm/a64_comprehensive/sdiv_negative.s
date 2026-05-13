/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFC"
  }
}
*/

.text
.global _start
_start:
    mov x0, #-12
    mov x1, #3
    sdiv x0, x0, x1   // -12 / 3 = -4
    brk #0

