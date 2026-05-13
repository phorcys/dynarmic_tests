/* CONFIG
{
  "RegData": {
    "X0": "0x00000000000000FF"
  }
}
*/
// MOVI 16 bytes

.text
.global _start
_start:
    movi v0.16b, #0xFF
    umov w0, v0.b[0]
    brk #0
