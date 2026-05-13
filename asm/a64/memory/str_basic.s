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
    str x0, [sp]
    mov x0, #0
    ldr x0, [sp]
    add sp, sp, #32
    brk #0
