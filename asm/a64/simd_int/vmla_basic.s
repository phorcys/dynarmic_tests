/* CONFIG
{
  "RegData": {
    "X0": "0x0000000500000005"
  }
}
*/
// VMLA basic - multiply-accumulate

.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    movi v2.4s, #3
    mla v2.4s, v0.4s, v1.4s  // v2 += v0 * v1 = 3 + 1*2 = 5
    mov x0, v2.d[0]
    brk #0
