/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000001234"
  }
}
*/

.text
.global _start
_start:
    sub sp, sp, #32
    mov x1, #0x1234
    stxr w0, x1, [sp]
    add sp, sp, #32
    brk #0

