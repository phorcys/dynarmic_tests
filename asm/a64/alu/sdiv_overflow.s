/* CONFIG
{
  "RegData": {
    "X0": "0x8000000000000000"
  }
}
*/
// SDIV overflow

.text
.global _start
_start:
    mov x0, #0x8000000000000000
    movk x0, #0x8000, lsl #48
    mov x1, #-1
    sdiv x0, x0, x1
    brk #0
