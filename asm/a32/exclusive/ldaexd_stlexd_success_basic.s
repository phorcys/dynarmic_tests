/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11223344",
    "R1": "0x55667788",
    "R2": "0x00000000",
    "R4": "0x99AABBCC",
    "R5": "0xDDEEFF00",
    "R6": "0x99AABBCC",
    "R7": "0xDDEEFF00"
  }
}
*/
.arch armv8-a
.text
.global _start
_start:
    sub sp, sp, #16
    movw r7, #0x3344
    movt r7, #0x1122
    str r7, [sp]
    movw r7, #0x7788
    movt r7, #0x5566
    str r7, [sp, #4]

    mov r8, sp
    ldaexd r0, r1, [r8]
    movw r4, #0xBBCC
    movt r4, #0x99AA
    movw r5, #0xFF00
    movt r5, #0xDDEE
    stlexd r2, r4, r5, [r8]
    ldr r6, [sp]
    ldr r7, [sp, #4]

    add sp, sp, #16
    bkpt #0
