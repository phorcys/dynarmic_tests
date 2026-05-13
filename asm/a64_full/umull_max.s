/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFE00000001"
  }
}
*/

.text
.global _start
_start:
    mov w1, #0xFFFFFFFF
    mov w2, #0xFFFFFFFF
    umull x0, w1, w2
    brk #0

