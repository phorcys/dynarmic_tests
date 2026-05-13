/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFE"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    cmp xzr, xzr
    cinv x0, x0, eq
    brk #0

