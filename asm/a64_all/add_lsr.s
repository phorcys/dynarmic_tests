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
    mov x1, #0x10
    add x0, x0, x1, lsr #2
    brk #0

