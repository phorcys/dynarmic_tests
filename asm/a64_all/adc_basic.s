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
    mov x0, #1
    mov x1, #1
    subs xzr, x1, #0
    adc x0, x0, xzr
    brk #0

