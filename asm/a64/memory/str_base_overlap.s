/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000000"
  }
}
*/
// STR base-source overlap: store the base register value through itself.

.text
.global _start
_start:
    add x0, sp, #16
    str x0, [x0]
    ldr x1, [sp, #16]
    sub x0, x1, x0
    mov x1, #0

    brk #0
