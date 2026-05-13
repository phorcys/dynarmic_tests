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
    fmov d0, #2.5
    frintx d0, d0
    fmov x0, d0
    brk #0

