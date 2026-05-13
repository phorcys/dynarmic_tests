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
    fmov s0, #2.0
    fcvt d0, s0
    fmov x0, d0
    brk #0

