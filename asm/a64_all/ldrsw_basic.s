/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/

.text
.global _start
_start:
    sub sp, sp, #16
    mov x0, #0xFFFFFFFF
    str w0, [sp]
    mov x0, #0
    ldrsw x0, [sp]
    add sp, sp, #16
    brk #0

