/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// UQSUB vector - unsigned saturating sub (saturates to 0)

.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    uqsub v2.4s, v0.4s, v1.4s
    mov x0, v2.d[0]
    brk #0
