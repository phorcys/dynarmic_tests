/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x00000000000000FF"}
}
*/
.text
.global _start
_start:
    mov x0, #0xFF00
    ubfx x0, x0, #8, #8
    brk #0
