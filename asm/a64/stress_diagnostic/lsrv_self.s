/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/
// LSRV: 8 >> 2 = 2

.text
.global _start
_start:
    mov x0, #8
    mov x1, #2
    lsrv x0, x0, x1
    brk #0
