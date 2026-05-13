/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000042"
  }
}
*/
// INS byte

.text
.global _start
_start:
    movi v0.16b, #0
    mov w1, #0x42
    ins v0.b[0], w1
    umov w0, v0.b[0]
    brk #0
