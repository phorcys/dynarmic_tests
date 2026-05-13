/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/
// UDIV basic

.text
.global _start
_start:
    mov x0, #10
    mov x1, #5
    udiv x0, x0, x1
    brk #0
