/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFEB"
  }
}
*/
// CSINV ge false - ~20 = 0xFFFFFFFFFFFFFFEB

.text
.global _start
_start:
    mov x0, #10
    mov x1, #20
    cmp x0, x1          // 10 < 20
    csinv x2, x0, x1, ge  // if ge (false), select ~x1 = ~20
    mov x0, x2
    brk #0
