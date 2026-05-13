/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x3FF0000000000000"
  }
}
*/

.text
.global _start
_start:
    fmov d0, #1.0
    fmov x0, d0
    brk #0

