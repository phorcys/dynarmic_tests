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
    fcvtms x0, d0  // round to -inf: 2.5 -> 2
    brk #0

