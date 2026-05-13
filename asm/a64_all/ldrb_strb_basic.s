/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000034"
  }
}
*/

.text
.global _start
_start:
    sub sp, sp, #16
    mov x0, #0x1234
    strb w0, [sp]
    mov x0, #0
    ldrb w0, [sp]
    add sp, sp, #16
    brk #0

