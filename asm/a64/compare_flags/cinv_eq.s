/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF00"
  }
}
*/
// CINV when condition true

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #1
    cmp x1, #1      // Z=1
    cinv x0, x0, eq
    brk #0
