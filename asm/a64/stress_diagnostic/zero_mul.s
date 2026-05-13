/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Any * Zero = Zero

.text
.global _start
_start:
    mov x0, #42
    mov x1, #0
    mul x0, x0, x1
    brk #0
