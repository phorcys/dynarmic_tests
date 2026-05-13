/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000014"
  }
}
*/
// CSEL gt false

.text
.global _start
_start:
    mov x0, #10
    mov x1, #20
    cmp x0, x1
    csel x2, x0, x1, gt  // if 10 > 20 (false), select x1
    mov x0, x2
    brk #0
