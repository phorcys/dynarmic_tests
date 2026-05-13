/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000060000000"}
}
*/
.text
.global _start
_start:
    fmov d0, #1.0
    fmov d1, #1.0
    fcmp d0, d1
    mrs x0, nzcv  // Z=1, C=1 -> 0x60000000
    brk #0
