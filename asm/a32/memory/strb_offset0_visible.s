/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000011" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #8
    mov r1, #0x11
    strb r1, [sp]
    ldrb r0, [sp]
    add sp, sp, #8
    bkpt #0
