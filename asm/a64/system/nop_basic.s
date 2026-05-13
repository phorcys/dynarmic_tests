/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// NOP basic

.text
.global _start
_start:
    mov x0, #1
    nop
    brk #0
