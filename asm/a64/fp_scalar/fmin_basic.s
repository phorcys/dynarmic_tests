/* CONFIG
{
  "RegData": {
    "X0": "0x0000000040000000"
  }
}
*/
// FMIN basic

.text
.global _start
_start:
    mov w0, #0x40000000    // 2.0f
    mov w1, #0x40400000    // 3.0f
    fmov s0, w0
    fmov s1, w1
    fmin s0, s0, s1        // min(2.0, 3.0) = 2.0
    fmov w0, s0
    brk #0
