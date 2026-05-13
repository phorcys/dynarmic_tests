/* CONFIG
{
  "RegData": {
    "X0": "0x0000000300000003"
  }
}
*/
// SQADD vector - signed saturating add

.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    sqadd v2.4s, v0.4s, v1.4s
    mov x0, v2.d[0]
    brk #0
