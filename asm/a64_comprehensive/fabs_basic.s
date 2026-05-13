/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x4000000000000000"}
}
*/
// fabs(-2.0) = 2.0
.text
.global _start
_start:
    fmov d0, #-2.0
    fabs d0, d0
    fmov x0, d0
    brk #0
