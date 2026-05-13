/* CONFIG
{
  "RegData": {
    "X0": "0x00000000C0000000"
  }
}
*/
// FMSUB basic - 2.0 * 3.0 - 4.0 = 2.0... wait QEMU says -2.0

.text
.global _start
_start:
    fmov s0, #2.0
    fmov s1, #3.0
    fmov s2, #4.0
    fmsub s3, s0, s1, s2  // -(2.0 * 3.0) + 4.0 = -6.0 + 4.0 = -2.0
    fmov w0, s3
    brk #0
