/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000022" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #8
    mov r1, #0x22
    strb r1, [sp, #1]
    ldrb r0, [sp, #1]
    add sp, sp, #8
    bkpt #0
