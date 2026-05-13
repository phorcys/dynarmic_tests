/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x4010000000000000"
  }
}
*/

.text
.global _start
_start:
    fmov d0, #2.0
    fmov d1, #2.0
    fmul d0, d0, d1
    fmov x0, d0
    brk #0

