/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    subs x0, x0, #1
    mrs x0, nzcv  // Z=1, C=1 -> 0x60000000
    brk #0

