/* CONFIG
{
  "RegData": {
    "X0": "0x0000000200000002"
  }
}
*/
// VBIC basic

.text
.global _start
_start:
    movi v0.4s, #3
    movi v1.4s, #1
    bic v2.16b, v0.16b, v1.16b  // v0 & ~v1 = 3 & ~1 = 2
    mov x0, v2.d[0]
    brk #0
