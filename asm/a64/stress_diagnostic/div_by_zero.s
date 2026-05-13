/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Division by zero returns 0

.text
.global _start
_start:
    mov x0, #42
    mov x1, #0
    udiv x0, x0, x1
    brk #0
