/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000003F"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    clz x0, x0
    brk #0

