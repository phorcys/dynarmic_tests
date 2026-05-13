/* CONFIG
{
  "RegData": {
    "X0": "0xF000000000000000"
  }
}
*/
// EXTR basic - extracts from (x0:x1) >> lsb, x0 is high part

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    extr x0, x0, x1, #4   // extract bits [67:4] from (0xFF:0) >> 4
    brk #0
