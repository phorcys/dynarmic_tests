/* CONFIG
{
  "RegData": {
    "X0": "0xC000000000000000"
  }
}
*/
// ROR basic

.text
.global _start
_start:
    mov x0, #3
    ror x0, x0, #2        // 3 rotated right by 2 = 0xC000000000000000
    brk #0
