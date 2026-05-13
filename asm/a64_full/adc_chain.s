/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003",
    "X1": "0x0000000000000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    subs xzr, x1, #0     // C=1
    adc x0, x0, x1       // x0 = 1 + 1 + 1 = 3
    adcs xzr, xzr, xzr   // C=0
    adc x1, xzr, xzr     // x1 = 0 + 0 + 0 = 0
    brk #0

