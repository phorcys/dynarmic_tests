/* CONFIG
{
  "RegData": {
    "X0": "0x00000000000000FF"
  }
}
*/
// AND self

.text
.global _start
_start:
    mov x0, #0xFF
    and x0, x0, x0        // 0xFF & 0xFF = 0xFF
    brk #0
