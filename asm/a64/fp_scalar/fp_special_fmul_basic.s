/* CONFIG
{
  "RegData": {
    "X0": "0x0000000040000000"
  }
}
*/
// FMUL basic - 1.0 * 2.0 = 2.0 (float encoding 0x40000000)

.text
.global _start
_start:
    fmov s0, #1.0
    fmov s1, #2.0
    fmul s2, s0, s1
    fmov w0, s2
    brk #0
