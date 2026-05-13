/* CONFIG
{
  "RegData": {
    "X0": "0x0000000100000000"
  }
}
*/
// MUL produces high bits

.text
.global _start
_start:
    mov x0, #0x10000
    mul x0, x0, x0
    brk #0
