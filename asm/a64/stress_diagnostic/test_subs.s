/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000A",
    "X1": "0x0000000080000000"
  }
}
*/
.text
.global _start
_start:
    mov x0, #10
    subs xzr, x0, #15   // 10 - 15 = -5, sets N=1
    mrs x1, nzcv
    brk #0
