/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000004"
  }
}
*/
// MSUB basic

.text
.global _start
_start:
    mov x0, #2
    mov x1, #3
    mov x2, #10
    msub x0, x0, x1, x2   // x0 = x2 - x0*x1 = 10 - 2*3 = 4
    brk #0
