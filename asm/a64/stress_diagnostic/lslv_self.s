/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/
// LSLV: 1 << 1 = 2

.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    lslv x0, x0, x1
    brk #0
