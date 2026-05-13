/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000004"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    add x0, x0, x0     // x0 = 1 + 1 = 2
    add x0, x0, x0     // x0 = 2 + 2 = 4
    brk #0

