/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x8000000000000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    mov x1, #63
    lsl x0, x0, x1
    brk #0

