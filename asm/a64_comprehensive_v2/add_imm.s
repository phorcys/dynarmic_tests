/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    add x0, x0, #0x1000
    brk #0

