/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFA"
  }
}
*/
// CINV true

.text
.global _start
_start:
    mov x0, #5
    cmp x0, #3
    cinv x0, x0, gt     // if 5 > 3, x0 = ~x0
    brk #0
