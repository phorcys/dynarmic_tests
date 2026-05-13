/* CONFIG
{
  "RegData": {
    "X0": "0x80000000"
  }
}
*/
// SUB underflow: 0 - 1

.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    subs x2, x0, x1
    mrs x0, nzcv
    brk #0
