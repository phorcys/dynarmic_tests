/* CONFIG
{
  "RegData": {
    "X0": "0x000000004F800000"
  }
}
*/
// UCVTF basic

.text
.global _start
_start:
    mov x0, #0xFFFFFFFF
    ucvtf s0, x0
    fmov w0, s0
    brk #0
