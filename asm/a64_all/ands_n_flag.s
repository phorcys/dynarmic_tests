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
    mov x0, #0x8000000000000000
    ands x0, x0, x0
    mrs x0, nzcv
    brk #0

