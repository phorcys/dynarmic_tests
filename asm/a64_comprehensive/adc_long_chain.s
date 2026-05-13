/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0xFFFFFFFFFFFFFFFF"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    adds x0, x0, #1
    adcs x1, x1, xzr  // x1 = 0xFFFFFFFFFFFFFFFF, C=1
    adcs x1, x1, xzr  // x1 = 0x0000000000000000, C=1
    adc x0, xzr, xzr  // x0 = 1
    brk #0

