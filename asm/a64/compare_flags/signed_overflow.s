/* CONFIG
{
  "NZCV": "0x0000000A"
}
*/
// Signed overflow

.text
.global _start
_start:
    mov x0, #0x7FFFFFFFFFFFFFFF  // max positive
    mov x1, #1
    adds x0, x0, x1            // overflow: N=1, V=1
    mrs x0, nzcv
    brk #0
