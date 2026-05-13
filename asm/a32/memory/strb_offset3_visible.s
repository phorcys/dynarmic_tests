/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000044" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #8
    mov r1, #0x44
    strb r1, [sp, #3]
    ldrb r0, [sp, #3]
    add sp, sp, #8
    bkpt #0
