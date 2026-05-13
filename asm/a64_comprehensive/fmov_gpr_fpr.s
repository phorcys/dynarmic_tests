/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000042"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0x42
    fmov d0, x0
    fmov x0, d0
    brk #0

