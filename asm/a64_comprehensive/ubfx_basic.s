/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000001E"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xF8
    ubfx x0, x0, #2, #5
    brk #0

