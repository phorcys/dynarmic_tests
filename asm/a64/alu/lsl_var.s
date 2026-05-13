/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000004"
  }
}
*/
// LSL variable

.text
.global _start
_start:
    mov x0, #1
    mov x1, #2
    lsl x0, x0, x1       // 1 << 2 = 4
    brk #0
