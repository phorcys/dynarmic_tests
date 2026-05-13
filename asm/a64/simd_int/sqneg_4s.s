/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// SQNEG vector - signed saturating negate

.text
.global _start
_start:
    movi v0.4s, #1
    sqneg v1.4s, v0.4s
    mov x0, v1.d[0]
    brk #0
