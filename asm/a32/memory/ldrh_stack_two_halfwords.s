/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000078", "R1": "0x00000056" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16

    mov r3, #0x78
    strh r3, [sp]
    mov r3, #0x56
    strh r3, [sp, #2]

    ldrh r0, [sp]
    ldrh r1, [sp, #2]
    add sp, sp, #16
    bkpt #0
