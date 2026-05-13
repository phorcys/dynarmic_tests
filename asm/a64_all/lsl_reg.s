/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000010"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    mov x1, #4
    lsl x0, x0, x1
    brk #0

