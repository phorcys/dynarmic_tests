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
    mov x0, #0
    mov x1, #1
    sqsub x0, x0, x1   // 0 - 1 = -1, 但有符号饱和到最小值
    brk #0

