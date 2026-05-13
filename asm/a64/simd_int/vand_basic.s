/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000000F"
  }
}
*/
// VAND basic

.text
.global _start
_start:
    movi v0.16b, #0x0F
    movi v1.16b, #0xFF
    and v0.16b, v0.16b, v1.16b
    umov w0, v0.b[0]
    brk #0
