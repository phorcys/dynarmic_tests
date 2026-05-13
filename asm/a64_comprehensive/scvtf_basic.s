/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x4000000000000000"}
}
*/
// scvtf: int 2 -> double 2.0
.text
.global _start
_start:
    mov x0, #2
    scvtf d0, x0
    fmov x0, d0
    brk #0
