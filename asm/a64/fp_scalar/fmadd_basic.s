/* CONFIG
{
  "RegData": {
    "X0": "0x0000000041200000"
  }
}
*/
// FMADD basic - 2.0 * 3.0 + 4.0 = 10.0 (float encoding 0x41200000)

.text
.global _start
_start:
    fmov s0, #2.0
    fmov s1, #3.0
    fmov s2, #4.0
    fmadd s3, s0, s1, s2
    fmov w0, s3
    brk #0
