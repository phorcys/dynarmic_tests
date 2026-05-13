/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234"
  }
}
*/

.text
.global _start
_start:
    mov x1, #0x8000
    movk x1, #0x8000, lsl #16
    movk x1, #0x8000, lsl #32
    movk x1, #0x8000, lsl #48  // x1 = 0x8000800080008000
    mov x0, #0x1000
    add x0, x0, x1, uxtw, lsl #3
    brk #0

