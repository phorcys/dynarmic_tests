/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000000000002"}
}
*/
.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    mov x2, #1
    subs xzr, x2, #0   // 1 - 0 = 1, sets C=1 (no borrow)
    adc x0, x1, xzr    // x0 = 1 + 0 + C = 2
    brk #0
