/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11223344",
    "R1": "0x55667788",
    "R4": "0x00000001",
    "R5": "0x00000004"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16

    ldr r0, =0x11223344
    str r0, [sp]
    ldr r0, =0x55667788
    str r0, [sp, #4]

    mov r4, #4
    mov r5, sp
    ldr r0, [r5], r4
    ldr r1, [r5]
    sub r5, r5, sp
    lsr r4, r4, #2

    add sp, sp, #16
    bkpt #0
