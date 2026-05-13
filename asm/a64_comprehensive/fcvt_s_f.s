/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000040000000"}
}
*/
// fcvt s0, d0: double 2.0 to float 2.0
.text
.global _start
_start:
    fmov d0, #2.0
    fcvt s0, d0
    fmov w0, s0
    brk #0
