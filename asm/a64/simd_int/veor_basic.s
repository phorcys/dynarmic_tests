/* CONFIG
{
  "RegData": {
    "X0": "0x00000000000000F0"
  }
}
*/
// VEOR basic

.text
.global _start
_start:
    movi v0.16b, #0xFF
    movi v1.16b, #0x0F
    eor v0.16b, v0.16b, v1.16b   // 0xFF ^ 0x0F = 0xF0
    umov w0, v0.b[0]
    brk #0
