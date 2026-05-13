/* CONFIG
{
  "RegData": {
    "X0": "0x00000000000000FF"
  }
}
*/
// BFXIL basic - extract 8 bits from pos 8, insert at LSB

.text
.global _start
_start:
    mov x0, #0xFF00
    mov x1, #0
    bfxil x1, x0, #8, #8  // extract 8 bits from x0 at pos 8, insert at LSB
    mov x0, x1
    brk #0
