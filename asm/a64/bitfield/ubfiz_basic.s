/* CONFIG
{
  "RegData": {
    "X0": "0x00000000000000FF"
  }
}
*/
// UBFIZ basic

.text
.global _start
_start:
    mov x0, #0xFF
    ubfiz x0, x0, #0, #8   // insert 8 bits at bit 0
    brk #0
