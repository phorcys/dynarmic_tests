/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/

.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #1.0
    fcmp d0, d1
    cset x0, eq
    brk #0

