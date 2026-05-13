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
    cmp xzr, xzr
    csel x0, x0, x1, eq
    brk #0

