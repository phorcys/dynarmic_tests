/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    cmp x0, #0
    ccmn x0, #0, #0x0, eq
    mrs x0, nzcv
    brk #0

