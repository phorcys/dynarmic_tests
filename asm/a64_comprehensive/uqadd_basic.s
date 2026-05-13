/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xFFFF
    movk x0, #0xFFFF, lsl #16
    movk x0, #0xFFFF, lsl #32
    movk x0, #0xFFFF, lsl #48
    mov x1, #1
    uqadd x0, x0, x1   // 饱和到 0xFFFFFFFFFFFFFFFF
    brk #0

