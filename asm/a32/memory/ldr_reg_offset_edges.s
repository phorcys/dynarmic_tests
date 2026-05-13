/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11223344",
    "R1": "0x55667788",
    "R2": "0x99AABBCC",
    "R3": "0xDDEEFF00"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #48

    ldr r4, =0x11223344
    str r4, [sp, #0]
    ldr r4, =0x55667788
    str r4, [sp, #4]
    ldr r4, =0x99AABBCC
    str r4, [sp, #8]
    ldr r4, =0xDDEEFF00
    str r4, [sp, #12]

    mov r5, sp
    mov r6, #0
    ldr r0, [r5, r6]
    mov r6, #4
    ldr r1, [r5, r6]
    mov r6, #8
    ldr r2, [r5, r6]
    mov r6, #12
    ldr r3, [r5, r6]

    add sp, sp, #48
    bkpt #0
