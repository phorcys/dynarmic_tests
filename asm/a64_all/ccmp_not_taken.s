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
    mov x0, #0
    cmp x0, #1
    ccmp x0, #0, #0xF, eq
    mrs x0, nzcv
    brk #0

