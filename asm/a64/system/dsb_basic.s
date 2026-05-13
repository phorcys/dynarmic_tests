/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// DSB basic

.text
.global _start
_start:
    mov x0, #1
    dsb sy
    brk #0
