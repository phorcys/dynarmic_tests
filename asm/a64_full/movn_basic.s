/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFE"
  }
}
*/

.text
.global _start
_start:
    movn x0, #1
    brk #0

