/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #3
    cmp x0, #5
    mrs x0, nzcv  // N=1
    brk #0

