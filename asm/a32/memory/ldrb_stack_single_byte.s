/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000012" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    mov r2, #0x12
    strb r2, [sp]
    ldrb r0, [sp]
    add sp, sp, #16
    bkpt #0
