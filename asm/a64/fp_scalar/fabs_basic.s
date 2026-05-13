/* CONFIG
{
  "RegData": {
    "X0": "0x000000003F800000"
  }
}
*/
// FABS basic

.text
.global _start
_start:
    mov w0, #0xBF800000    // -1.0f
    fmov s0, w0
    fabs s0, s0            // |-1.0| = 1.0
    fmov w0, s0
    brk #0
