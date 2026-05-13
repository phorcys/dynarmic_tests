/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000000F"
  }
}
*/
// BSL bitwise select - when mask is 0xFF, select all bits from v1

.text
.global _start
_start:
    movi v0.16b, #0xFF
    movi v1.16b, #0x0F
    movi v2.16b, #0xF0
    bsl v0.16b, v1.16b, v2.16b
    umov w0, v0.b[0]
    brk #0
