/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// DMB basic

.text
.global _start
_start:
    mov x0, #1
    dmb sy
    brk #0
