/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000FF"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xF0
    orr x0, x0, #0x0F
    brk #0

