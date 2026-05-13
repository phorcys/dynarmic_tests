/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFF0FF"
  }
}
*/

.text
.global _start
_start:
    movn x0, #0xF00
    brk #0

