/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFE"
  }
}
*/
// SDIV negative

.text
.global _start
_start:
    mov x0, #-10
    mov x1, #5
    sdiv x0, x0, x1       // -10 / 5 = -2
    brk #0
