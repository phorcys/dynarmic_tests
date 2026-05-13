/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// ADDS self zero: 0 + 0 = 0, Z=1

.text
.global _start
_start:
    mov x0, #0
    adds x0, x0, x0
    brk #0
