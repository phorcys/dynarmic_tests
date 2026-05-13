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
    lsl x0, x0, #4
    brk #0

