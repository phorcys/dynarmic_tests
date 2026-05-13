/* CONFIG
{
  "RegData": {
    "X0": "0x000000FF000000FF"
  }
}
*/
// UQADD vector - add with immediate (each 32-bit lane = 0xFF)

.text
.global _start
_start:
    movi v0.4s, #0xFF
    movi v1.4s, #0
    uqadd v2.4s, v0.4s, v1.4s
    mov x0, v2.d[0]
    brk #0
