/* CONFIG
{
  "RegData": {
    "X0": "0x0000000040A00000"
  }
}
*/
// FDIV basic - 10.0 / 2.0 = 5.0 (float encoding 0x40a00000)

.text
.global _start
_start:
    fmov s0, #10.0
    fmov s1, #2.0
    fdiv s2, s0, s1
    fmov w0, s2
    brk #0
