/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/

.text
.global _start
_start:
    fmov d0, #2.5
    fcvtzs x0, d0
    brk #0

