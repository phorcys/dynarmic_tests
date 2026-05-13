/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// EXTR basic - extract from x0:x1 pair at position 0

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    extr x0, x0, x1, #0   // extract from x0:x1 at position 0 = x0 low bits
    brk #0
