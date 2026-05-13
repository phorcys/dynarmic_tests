/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000F0"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xF
    mov x1, #60
    ror x0, x0, x1
    brk #0

