/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234"
  }
}
*/

.text
.global _start
_start:
    sub sp, sp, #32
    mov x0, #0x1234
    str x0, [sp], #8
    mov x0, #0
    ldr x0, [sp, #-8]!
    add sp, sp, #16
    brk #0

