/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000020000000"
  }
}
*/

.text
.global _start
_start:
    fmov d0, #2.0
    fmov d1, #1.0
    fcmp d0, d1
    mrs x0, nzcv
    brk #0

