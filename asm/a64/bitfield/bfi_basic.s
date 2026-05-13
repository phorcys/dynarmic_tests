/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000FF00"
  }
}
*/
// BFI basic

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    bfi x1, x0, #8, #8    // insert 8 bits from x0 into x1 at position 8
    mov x0, x1
    brk #0
