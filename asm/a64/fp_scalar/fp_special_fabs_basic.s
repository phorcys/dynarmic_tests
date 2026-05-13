/* CONFIG
{
  "RegData": {
    "X0": "0x0000000040000000"
  }
}
*/
// FABS basic - |-2.0| = 2.0 (float encoding 0x40000000)

.text
.global _start
_start:
    fmov s0, #-2.0
    fabs s1, s0
    fmov w0, s1
    brk #0
