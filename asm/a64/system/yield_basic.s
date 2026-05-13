/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// YIELD basic

.text
.global _start
_start:
    mov x0, #1
    yield
    brk #0
