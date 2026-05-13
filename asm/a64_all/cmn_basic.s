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
    cmn x0, #0
    mrs x0, nzcv
    brk #0

