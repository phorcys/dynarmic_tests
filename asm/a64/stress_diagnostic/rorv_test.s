/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000000C"
  }
}
*/
// RORV: 3 rotated right by 62 = 3 << 2 = 12 = 0xC

.text
.global _start
_start:
    mov x0, #3
    mov x1, #62
    rorv x0, x0, x1
    brk #0
