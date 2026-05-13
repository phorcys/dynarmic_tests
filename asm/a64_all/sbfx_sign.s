/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
.text
.global _start
_start:
    mov x0, #0xF8
    sbfx x0, x0, #3, #4
    brk #0
