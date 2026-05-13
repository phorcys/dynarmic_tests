/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// LSR variable

.text
.global _start
_start:
    mov x0, #4
    mov x1, #2
    lsr x0, x0, x1       // 4 >> 2 = 1
    brk #0
