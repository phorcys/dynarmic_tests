/* CONFIG
{
  "RegData": {
    "X0": "0x0000000100000000"
  }
}
*/
// ROR by 32

.text
.global _start
_start:
    mov x0, #1
    ror x0, x0, #32
    brk #0
