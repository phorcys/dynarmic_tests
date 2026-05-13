/* CONFIG
{
  "RegData": {
    "X0": "0x00000000000000FF"
  }
}
*/
// VORR basic

.text
.global _start
_start:
    movi v0.16b, #0x0F
    movi v1.16b, #0xF0
    orr v0.16b, v0.16b, v1.16b   // 0x0F | 0xF0 = 0xFF
    umov w0, v0.b[0]
    brk #0
