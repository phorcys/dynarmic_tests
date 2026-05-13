/* CONFIG
{
  "RegData": {
    "X0": "0x00000000000000F0"
  }
}
*/
// BFXIL basic

.text
.global _start
_start:
    mov x0, #0xFF00
    mov x1, #0
    bfxil x1, x0, #4, #8  // extract 8 bits from x0[11:4] and insert into x1[7:0]
    mov x0, x1
    brk #0
