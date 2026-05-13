/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x00000000FFFFFFFF"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xFF
    movk x0, #0xFFFF, lsl #16
    movk x0, #0xFFFF, lsl #32  // x0 = all 1s
    mov x1, #0
    bfi x1, x0, #0, #1
    brk #0

