/* CONFIG
{
  "RegData": {
    "S0": "0x00000000"
  }
}
*/
// 0.0 + 0.0 = 0.0

.text
.global _start
_start:
    fmov s0, wzr
    fmov s1, wzr
    fadd s0, s0, s1
    brk #0
