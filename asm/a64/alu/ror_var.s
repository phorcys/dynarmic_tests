/* CONFIG
{
  "RegData": {
    "X0": "0x4000000000000000"
  }
}
*/
// ROR variable

.text
.global _start
_start:
    mov x0, #1
    mov x1, #2
    ror x0, x0, x1       // rotate 1 right by 2
    brk #0
