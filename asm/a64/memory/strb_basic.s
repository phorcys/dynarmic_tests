/* CONFIG
{
  "Match": "All",
  "RegData": {
    "W0": "0x000000AB"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #32
    mov w0, #0xAB
    strb w0, [sp]
    mov w0, #0
    ldrb w0, [sp]
    add sp, sp, #32
    brk #0
