/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000030000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    adds x0, x0, #0    // Z=1, C=0, N=0, V=0 -> NZCV = 0x40000000
    mrs x1, nzcv
    mov x0, x1
    brk #0

