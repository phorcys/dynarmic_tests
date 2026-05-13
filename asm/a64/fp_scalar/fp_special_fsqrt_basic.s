/* CONFIG
{
  "RegData": {
    "X0": "0x0000000040000000"
  }
}
*/
// FSQRT basic - sqrt(4.0) = 2.0 (float encoding 0x40000000)

.text
.global _start
_start:
    fmov s0, #4.0
    fsqrt s1, s0
    fmov w0, s1
    brk #0
