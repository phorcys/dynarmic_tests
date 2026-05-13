/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFE"
  }
}
*/
// MVN basic

.text
.global _start
_start:
    mov x0, #1
    mvn x0, x0            // ~1 = -2
    brk #0
