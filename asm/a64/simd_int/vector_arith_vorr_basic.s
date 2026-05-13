/* CONFIG
{
  "RegData": {
    "X0": "0x0000000300000003"
  }
}
*/
// VORR basic

.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    orr v2.16b, v0.16b, v1.16b
    mov x0, v2.d[0]
    brk #0
