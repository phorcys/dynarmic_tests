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
    fmov d0, #3.0
    fcvtas x0, d0
    brk #0
