/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000F"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xF0
    lsr x0, x0, #4
    brk #0

