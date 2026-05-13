/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF00"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xFF
    mvn x0, x0
    brk #0

