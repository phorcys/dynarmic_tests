/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000064"
  }
}
*/
// MUL self

.text
.global _start
_start:
    mov x0, #10
    mul x0, x0, x0        // 10 * 10 = 100
    brk #0
