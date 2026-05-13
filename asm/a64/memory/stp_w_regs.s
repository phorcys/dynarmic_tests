/* CONFIG
{
  "Match": "All",
  "RegData": {
    "W0": "0x00005678",
    "W1": "0x0000DEF0"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #32
    mov w0, #0x5678
    mov w1, #0xDEF0
    stp w0, w1, [sp]
    mov w0, #0
    mov w1, #0
    ldp w0, w1, [sp]
    add sp, sp, #32
    brk #0
