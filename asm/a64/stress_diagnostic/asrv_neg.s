/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFC"
  }
}
*/
// ASRV: -16 >> 2 = -4

.text
.global _start
_start:
    mov x0, #-16
    mov x1, #2
    asrv x0, x0, x1
    brk #0
