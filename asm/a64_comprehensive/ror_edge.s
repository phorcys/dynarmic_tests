/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xF00000000000000F"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xF
    movk x0, #0xF000, lsl #48  // x0 = 0xF00000000000000F
    ror x0, x0, #4              // 应该循环
    brk #0

