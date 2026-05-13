/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF00"
  }
}
*/
// MVN self: bitwise NOT

.text
.global _start
_start:
    mov x0, #0xFF
    mvn x0, x0
    brk #0
