/* CONFIG
{
  "RegData": {
    "X0": "0x00000000BF800000"
  }
}
*/
// FNEG basic

.text
.global _start
_start:
    mov w0, #0x3F800000    // 1.0f
    fmov s0, w0
    fneg s0, s0            // -1.0f
    fmov w0, s0
    brk #0
