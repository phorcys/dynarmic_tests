/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// UDIV self: always 1

.text
.global _start
_start:
    mov x0, #42
    udiv x0, x0, x0
    brk #0
