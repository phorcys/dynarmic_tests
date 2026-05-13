/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// EOR self

.text
.global _start
_start:
    mov x0, #-1
    eor x0, x0, x0        // -1 ^ -1 = 0
    brk #0
