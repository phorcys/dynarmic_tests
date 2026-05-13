/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000090000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0x7FFFFFFFFFFFFFFF
    adds x0, x0, #1
    mrs x0, nzcv
    brk #0

