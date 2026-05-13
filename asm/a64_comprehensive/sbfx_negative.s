/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFF8"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xF8
    movk x0, #0, lsl #16
    sbfx x0, x0, #3, #5  // 提取有符号位
    brk #0

