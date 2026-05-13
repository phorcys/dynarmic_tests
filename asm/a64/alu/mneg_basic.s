/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFA"
  }
}
*/
// MNEG basic

.text
.global _start
_start:
    mov x0, #2
    mov x1, #3
    mneg x0, x0, x1       // -(2 * 3) = -6
    brk #0
