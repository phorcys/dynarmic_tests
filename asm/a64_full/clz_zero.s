/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000040"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    clz x0, x0
    brk #0

