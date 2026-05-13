/* CONFIG
{
  "Match": "All",
  "RegData": {
    "W0": "0x0000ABCD"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #32
    mov w0, #0xABCD
    strh w0, [sp]
    mov w0, #0
    ldrh w0, [sp]
    add sp, sp, #32
    brk #0
