/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/

.text
.global _start
_start:
    mov x0, #5
    mov x1, #3
    subs xzr, x0, x0
    sbc x0, x0, x1
    brk #0

