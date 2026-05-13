/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x3FF0000000000000"}
}
*/
// fmin(1.0, 2.0) = 1.0
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #2.0
    fmin d0, d0, d1
    fmov x0, d0
    brk #0
