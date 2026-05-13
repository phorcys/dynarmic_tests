/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000001E"
  }
}
*/
// ADD self with shift: 10 + (10<<1) = 10 + 20 = 30 = 0x1E

.text
.global _start
_start:
    mov x0, #10
    add x0, x0, x0, lsl #1
    brk #0
