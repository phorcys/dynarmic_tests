/* CONFIG
{
  "RegData": {
    "S0": "0x7F800000"
  }
}
*/
// 1.0 / 0.0 = Inf

.text
.global _start
_start:
    mov w0, #0x3F80
    movk w0, #0x0000, lsl #16
    fmov s0, w0
    fmov s1, wzr
    fdiv s0, s0, s1
    brk #0
