/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000000000002"}
}
*/
// fcvtzu: double 2.1 -> uint 2
.text
.global _start
_start:
    fmov d0, #2.1
    fcvtzu x0, d0
    brk #0
