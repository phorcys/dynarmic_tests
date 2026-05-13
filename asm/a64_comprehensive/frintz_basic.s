/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x4000000000000000"}
}
*/
// frintz: round to zero, 2.7 -> 2.0
.text
.global _start
_start:
    fmov d0, #2.7
    frintz d0, d0
    fmov x0, d0
    brk #0
