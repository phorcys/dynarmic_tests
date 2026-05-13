/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x8000000000000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    rbit x0, x0
    brk #0

