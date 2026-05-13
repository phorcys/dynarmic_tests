/* CONFIG
{
  "RegData": {
    "X0": "0x0000000100000001"
  }
}
*/
// VFMIN basic

.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    fmin v2.4s, v0.4s, v1.4s
    mov x0, v2.d[0]
    brk #0
