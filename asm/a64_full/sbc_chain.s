/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000000000002", "X1": "0x0000000000000002"}
}
*/
.text
.global _start
_start:
    mov x0, #5
    mov x1, #3
    subs xzr, x0, x0     // C=1 (no borrow: 5-5=0)
    sbc x0, x0, x1       // x0 = 5 - 3 - 0 = 2
    subs xzr, x1, x1     // C=1 (no borrow: 3-3=0)
    sbc x1, x0, x1       // x1 = 2 - 3 - 0 = -1
    add x1, x1, #3       // x1 = 2
    brk #0
