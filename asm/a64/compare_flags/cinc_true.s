/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000006"
  }
}
*/
// CINC true

.text
.global _start
_start:
    mov x0, #5
    cmp x0, #3
    cinc x0, x0, gt     // if 5 > 3, x0 = x0 + 1
    brk #0
