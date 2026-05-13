/* CONFIG
{
  "RegData": {
    "X0": "0x0000000040000000"
  }
}
*/
// FSQRT basic: sqrt(4.0) = 2.0

.text
.global _start
_start:
    mov w0, #0x40800000    // 4.0f
    fmov s0, w0
    fsqrt s0, s0           // sqrt(4.0) = 2.0 = 0x40000000
    fmov w0, s0
    brk #0
