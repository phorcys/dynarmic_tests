/* CONFIG
{
  "RegData": {
    "X0": "0x0000000100000001"
  }
}
*/
// VSUB basic

.text
.global _start
_start:
    movi v0.4s, #3
    movi v1.4s, #2
    sub v2.4s, v0.4s, v1.4s
    mov x0, v2.d[0]
    brk #0
