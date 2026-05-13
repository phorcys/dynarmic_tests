/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x4008000000000000"
  }
}
*/

.text
.global _start
_start:
    fmov d0, #2.5
    frintp d0, d0
    fmov x0, d0
    brk #0

