/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Zero + Zero = Zero

.text
.global _start
_start:
    mov x0, #0
    add x0, x0, x0
    brk #0
