/* CONFIG
{
  "RegData": {
    "X0": "0x8000000000000000"
  }
}
*/
// RBIT single bit

.text
.global _start
_start:
    mov x0, #1
    rbit x0, x0           // reverse: 0x8000000000000000
    brk #0
