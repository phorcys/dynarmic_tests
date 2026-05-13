/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000000A"
  }
}
*/
// CSEL lt true

.text
.global _start
_start:
    mov x0, #10
    mov x1, #20
    cmp x0, x1
    csel x2, x0, x1, lt  // if 10 < 20, select x0
    mov x0, x2
    brk #0
