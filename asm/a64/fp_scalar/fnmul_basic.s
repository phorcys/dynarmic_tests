/* CONFIG
{
  "RegData": {
    "X0": "0x00000000C0C00000"
  }
}
*/
// FNMUL basic - -(2.0 * 3.0) = -6.0 (float encoding 0xc0c00000)

.text
.global _start
_start:
    fmov s0, #2.0
    fmov s1, #3.0
    fnmul s2, s0, s1
    fmov w0, s2
    brk #0
