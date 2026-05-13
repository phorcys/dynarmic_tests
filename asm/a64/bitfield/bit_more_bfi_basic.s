/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000FF00"
  }
}
*/
// BFI basic - insert 8 bits of 0xFF at position 8

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    bfi x1, x0, #8, #8   // insert 8 bits of x0 at position 8
    mov x0, x1
    brk #0
