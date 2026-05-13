/* CONFIG
{
  "RegData": {
    "S0": "0x00000000"
  }
}
*/
// 0.0 / 1.0 = 0.0

.text
.global _start
_start:
    fmov s0, wzr
    mov w1, #0x3F80
    movk w1, #0x0000, lsl #16
    fmov s1, w1
    fdiv s0, s0, s1
    brk #0
