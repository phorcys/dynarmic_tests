/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000F00"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xF
    ubfiz x0, x0, #8, #4
    brk #0

