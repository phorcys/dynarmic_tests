/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/
// SDIV basic

.text
.global _start
_start:
    mov x0, #10
    mov x1, #5
    sdiv x0, x0, x1
    brk #0
