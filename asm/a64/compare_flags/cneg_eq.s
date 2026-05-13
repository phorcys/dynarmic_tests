/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF9C"
  }
}
*/
// CNEG when condition true

.text
.global _start
_start:
    mov x0, #100
    mov x1, #1
    cmp x1, #1      // Z=1
    cneg x0, x0, eq
    brk #0
