/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000012345678"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #32
    ldr x0, =0x12345678
    stur x0, [sp, #1]
    mov x0, #0
    ldur x0, [sp, #1]
    add sp, sp, #32
    brk #0
