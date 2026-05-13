/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000015"
  }
}
*/
// CSINC ne

.text
.global _start
_start:
    mov x0, #10
    mov x1, #20
    cmp x0, x1          // 10 != 20, ne
    csinc x2, x0, x1, eq  // if eq (false), select x1+1
    mov x0, x2
    brk #0
