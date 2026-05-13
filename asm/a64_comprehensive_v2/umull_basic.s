/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFFFFFF"
  }
}
*/

.text
.global _start
_start:
    mov w1, #0xFFFFFFFF
    mov w2, #1
    umull x0, w1, w2
    brk #0

