/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFFFFFE"
  }
}
*/

.text
.global _start
_start:
    mov w1, #0xFFFFFFFE
    movk w1, #0xFFFF, lsl #16
    mov w2, #1
    umull x0, w1, w2
    brk #0

