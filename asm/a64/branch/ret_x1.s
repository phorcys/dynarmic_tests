/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// RET using an explicit register operand instead of the implicit X30.

.text
.global _start
_start:
    adr x1, after_call
    b worker

worker:
    mov x0, #42
    ret x1

after_call:
    brk #0
