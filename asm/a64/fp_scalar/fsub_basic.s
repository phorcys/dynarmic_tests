/* CONFIG
{
  "RegData": {
    "X0": "0x000000003F800000"
  }
}
*/
// FSUB basic

.text
.global _start
_start:
    mov w0, #0x40000000    // 2.0f
    mov w1, #0x3F800000    // 1.0f
    fmov s0, w0
    fmov s1, w1
    fsub s0, s0, s1        // 2.0 - 1.0 = 1.0
    fmov w0, s0
    brk #0
