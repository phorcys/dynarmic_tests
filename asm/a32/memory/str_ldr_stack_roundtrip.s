/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000042" }
}
*/
.text
.global _start
_start:
    mov r0, #0x42
    sub sp, sp, #4
    str r0, [sp]
    mov r0, #0
    ldr r0, [sp]
    add sp, sp, #4
    bkpt #0
