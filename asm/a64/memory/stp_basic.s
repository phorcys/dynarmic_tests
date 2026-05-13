/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234",
    "X1": "0x0000000000005678"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #32
    mov x0, #0x1234
    mov x1, #0x5678
    stp x0, x1, [sp]
    mov x0, #0
    mov x1, #0
    ldp x0, x1, [sp]
    add sp, sp, #32
    brk #0
