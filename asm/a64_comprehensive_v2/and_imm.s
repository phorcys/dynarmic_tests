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
    mov x0, #0xFF
    and x0, x0, #0xF0
    brk #0

