/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000010"
  }
}
*/
// MADD basic

.text
.global _start
_start:
    mov x0, #2
    mov x1, #3
    mov x2, #10
    madd x0, x0, x1, x2   // 2 * 3 + 10 = 16 = 0x10
    brk #0
