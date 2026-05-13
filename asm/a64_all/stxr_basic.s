/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/

.text
.global _start
_start:
    sub sp, sp, #16
    mov x1, #0x1234
    ldxr x2, [sp]
    stxr w0, x1, [sp]
    add sp, sp, #16
    brk #0

