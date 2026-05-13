/* CONFIG
{
  "RegData": {
    "X0": "0x00000000C0000000"
  }
}
*/
// FNEG basic - -2.0 (float encoding 0xc0000000)

.text
.global _start
_start:
    fmov s0, #2.0
    fneg s1, s0
    fmov w0, s1
    brk #0
