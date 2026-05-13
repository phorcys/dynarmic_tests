/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    cmp xzr, xzr
    cinc x0, x0, eq
    brk #0

