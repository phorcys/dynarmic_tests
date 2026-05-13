/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// LSL by 0

.text
.global _start
_start:
    mov x0, #1
    lsl x0, x0, #0
    brk #0
