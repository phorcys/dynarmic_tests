/* CONFIG
{
  "RegData": {
    "X0": "0x0000000040000000"
  }
}
*/
// FCVT single-double

.text
.global _start
_start:
    mov w0, #0x40000000    // 2.0f
    fmov s0, w0
    fcvt d0, s0            // convert to double
    fcvt s0, d0            // convert back to single
    fmov w0, s0
    brk #0
