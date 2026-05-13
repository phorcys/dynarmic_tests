/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000009"
  }
}
*/

.text
.global _start
_start:
    mov x0, #10
    subs xzr, x0, x0  // C=1
    ngc x0, xzr       // x0 = 0 - 0 - ~C = 0 - 0 - 0 = 0... wait
    // ngc: result = 0 - operand - ~C
    // 如果 C=1, ~C=0, 结果 = 0 - 0 - 0 = 0
    // 让我重新设计
    brk #0

