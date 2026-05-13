/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #5
    cmp x0, #3
    mrs x0, nzcv  // C=1, N=0 -> 0x20000000
    brk #0

