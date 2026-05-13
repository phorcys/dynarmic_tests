/* CONFIG
{
  "RegData": {
    "X0": "0x000000003FC00000"
  }
}
*/
// FDIV basic: 3.0 / 2.0 = 1.5

.text
.global _start
_start:
    mov w0, #0x40400000    // 3.0f
    mov w1, #0x40000000    // 2.0f
    fmov s0, w0
    fmov s1, w1
    fdiv s0, s0, s1        // 3.0 / 2.0 = 1.5 = 0x3FC00000
    fmov w0, s0
    brk #0
