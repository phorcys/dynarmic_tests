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
    frintz d0, d0  // round to zero
    fmov x0, d0
    brk #0

