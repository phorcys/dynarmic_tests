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
    adds x0, x0, #0
    mrs x0, nzcv  // Z=1 -> 0x40000000
    brk #0

