/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000AA"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xAA
    mov x1, #0xBB
    mov x2, #1
    cmp x2, #0  // NE
    csel x0, x0, x1, ne
    brk #0

