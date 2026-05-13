/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// LSR by 63

.text
.global _start
_start:
    mov x0, #0x8000000000000000
    movk x0, #0x8000, lsl #48
    lsr x0, x0, #63
    brk #0
