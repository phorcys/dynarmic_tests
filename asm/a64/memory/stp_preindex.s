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
    add x2, sp, #16
    stp x0, x1, [x2, #-16]!
    mov x0, #0
    mov x1, #0
    ldp x0, x1, [x2]
    add sp, sp, #32
    brk #0
