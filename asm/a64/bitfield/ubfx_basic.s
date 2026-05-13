/* CONFIG
{
  "RegData": {
    "X0": "0x00000000000000FF"
  }
}
*/
// UBFX basic

.text
.global _start
_start:
    mov x0, #-1
    ubfx x0, x0, #0, #8    // extract 8 bits, zero extend
    brk #0
