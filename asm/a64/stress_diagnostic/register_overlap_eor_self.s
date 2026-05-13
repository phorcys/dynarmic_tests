/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// EOR self: always zero

.text
.global _start
_start:
    mov x0, #0xFF
    eor x0, x0, x0
    brk #0
