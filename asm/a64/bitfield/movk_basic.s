/* CONFIG
{
  "RegData": {
    "X0": "0x0000000100000042"
  }
}
*/
// MOVK basic

.text
.global _start
_start:
    mov x0, #0x42
    movk x0, #1, lsl #32
    brk #0
