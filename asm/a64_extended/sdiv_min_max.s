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
    mov x0, #0x8000000000000000
    mov x1, #-1
    sdiv x0, x0, x1  // INT_MIN / -1 应该返回 INT_MIN (不溢出)
    brk #0

