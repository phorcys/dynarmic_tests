/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// UZP1 deinterleave

.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    zip1 v2.4s, v0.4s, v1.4s
    uzp1 v3.4s, v2.4s, v2.4s
    mov w0, v3.s[0]
    brk #0
