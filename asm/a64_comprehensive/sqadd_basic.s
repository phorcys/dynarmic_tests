/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x7FFFFFFFFFFFFFFF"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0x7FFF
    movk x0, #0x7FFF, lsl #16
    movk x0, #0x7FFF, lsl #32
    movk x0, #0x7FFF, lsl #48  // x0 = 0x7FFF7FFF7FFF7FFF
    mov x1, #0x1000
    sqadd x0, x0, x1   // 饱和到 0x7FFFFFFFFFFFFFFF
    brk #0

