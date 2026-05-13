/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// SDIV by zero

.text
.global _start
_start:
    mov x0, #10
    mov x1, #0
    sdiv x0, x0, x1
    brk #0
