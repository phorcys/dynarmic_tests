/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x4000000000000000"}
}
*/
// frintm: round to -inf, 2.7 -> 2.0
.text
.global _start
_start:
    fmov d0, #2.7
    frintm d0, d0
    fmov x0, d0
    brk #0
