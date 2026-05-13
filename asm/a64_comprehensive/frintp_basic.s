/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x4008000000000000"}
}
*/
// frintp: round to +inf, 2.7 -> 3.0
.text
.global _start
_start:
    fmov d0, #2.7
    frintp d0, d0
    fmov x0, d0
    brk #0
