/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000033" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #8
    mov r1, #0x33
    strb r1, [sp, #2]
    ldrb r0, [sp, #2]
    add sp, sp, #8
    bkpt #0
