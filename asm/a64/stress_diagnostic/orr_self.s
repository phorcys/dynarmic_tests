/* CONFIG
{
  "RegData": {
    "X0": "0x00000000000000FF"
  }
}
*/
// ORR self

.text
.global _start
_start:
    mov x0, #0xFF
    orr x0, x0, x0        // 0xFF | 0xFF = 0xFF
    brk #0
