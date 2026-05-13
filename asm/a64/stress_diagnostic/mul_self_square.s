/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000031"
  }
}
*/
// MUL self: 7*7 = 49

.text
.global _start
_start:
    mov x0, #7
    mul x0, x0, x0
    brk #0
