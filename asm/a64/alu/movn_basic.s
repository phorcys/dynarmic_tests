/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFE"
  }
}
*/
// MOVN basic

.text
.global _start
_start:
    movn x0, #1            // ~1 = -2
    brk #0
