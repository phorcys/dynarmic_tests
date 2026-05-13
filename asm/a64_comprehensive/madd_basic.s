/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000007"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    mov x1, #2
    mov x2, #3
    madd x0, x1, x2, x0  // 1 + 2*3 = 7
    brk #0

