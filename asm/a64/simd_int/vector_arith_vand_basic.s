/* CONFIG
{
  "RegData": {
    "X0": "0x0000000100000001"
  }
}
*/
// VAND basic

.text
.global _start
_start:
    movi v0.4s, #3
    movi v1.4s, #1
    and v2.16b, v0.16b, v1.16b
    mov x0, v2.d[0]
    brk #0
