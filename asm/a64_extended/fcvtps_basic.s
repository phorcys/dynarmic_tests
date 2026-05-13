/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003"
  }
}
*/

.text
.global _start
_start:
    fmov d0, #2.5
    fcvtps x0, d0  // round to +inf: 2.5 -> 3
    brk #0

