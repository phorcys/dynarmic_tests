/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x4000000000000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #2
    ucvtf d0, x0
    fmov x0, d0
    brk #0

