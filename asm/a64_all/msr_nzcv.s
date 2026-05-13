/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000F0000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xF0000000
    msr nzcv, x0
    mrs x0, nzcv
    brk #0

