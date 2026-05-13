/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/

.text
.global _start
_start:
    sub sp, sp, #16
    ldaxr x0, [sp]
    add sp, sp, #16
    brk #0

