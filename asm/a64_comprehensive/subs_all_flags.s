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
    mov x0, #1
    subs x0, x0, #1    // Z=1, C=1, N=0, V=0 -> NZCV = 0x60000000
    mrs x1, nzcv
    mov x0, x1
    brk #0

