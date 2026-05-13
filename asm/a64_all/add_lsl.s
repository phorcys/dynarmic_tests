/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    add x0, x0, x1, lsl #2
    brk #0

