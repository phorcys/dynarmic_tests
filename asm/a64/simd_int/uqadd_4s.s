/* CONFIG
{
  "RegData": {
    "X0": "0x0000000300000003"
  }
}
*/
// UQADD vector - unsigned saturating add

.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    uqadd v2.4s, v0.4s, v1.4s
    mov x0, v2.d[0]
    brk #0
